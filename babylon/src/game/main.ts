// Entry point: the app shell of rattleramp/lib/ui/app.dart (attract → avatar → ride →
// attract, trick book, 20 s idle back to attract) around one Babylon engine. The ride
// part is rattle_game.dart + ride_screen.dart: fixed-rate RideSim, wall-clock releases
// mapped to ride time, DOM HUD, hint strip and stat card.
//
// Deep links: ?ride starts a ride straight away, ?pro a Pro ride, ?demo loops the
// autopilot on the ride screen (videos), ?debug shows FPS.
import { Engine } from '@babylonjs/core/Engines/engine';

import { Autopilot } from '../rules/autopilot';
import { avatarOf, PRESETS, type Avatar } from '../rules/avatar';
import { feasibleHints, pickHints } from '../rules/hints';
import { defaultConfig, type RideConfig } from '../rules/ride-config';
import { RideSim } from '../rules/ride-sim';
import { dailyTokenFor, defaultBook } from '../rules/trick-defs';
import { TrickParser } from '../rules/trick-parser';
import { AttractScreen } from '../ui/attract';
import { AvatarPicker } from '../ui/avatar-picker';
import { byId, Hud } from '../ui/hud';
import { applyStyle, nextStyle, Palette, type ArtStyle } from '../ui/palette';
import { loadSettings, saveSettings } from '../ui/settings';
import { EMPTY_SPRITES, loadSprites, type AvatarSprites } from '../ui/sprites';
import { StatCard } from '../ui/stat-card';
import { SwipePad } from '../ui/swipe-pad';
import { TrickBookScreen } from '../ui/trick-book';
import { TuningPanel } from '../ui/tuning';
import { RampScene, type WorldRect } from './scene';
import '../ui/style.css';

type Screen = 'attract' | 'avatar' | 'ride' | 'trickBook';

const t0 = performance.now();
const params = new URLSearchParams(location.search);
const debug = params.has('debug');
const demo = params.has('demo');

const canvas = byId('game') as HTMLCanvasElement;
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: false, antialias: true }, true);
const book = defaultBook();
const parser = new TrickParser(book);
const daily = dailyTokenFor(book, new Date());
const settings = loadSettings();
applyStyle(settings.style);
const hud = new Hud(daily.name);
const rideUi = byId('ride-ui');
let sprites: AvatarSprites = EMPTY_SPRITES;

const config = (): RideConfig => ({ ...defaultConfig(), ...settings.tuning });

// ── Game layer: one ride + scene; the attract screen rides the autopilot. ──
let screen: Screen = 'attract';
let pro = false;
let ride!: RideSim;
let rs: RampScene | null = null;
let bot: Autopilot | null = null;
let acc = 0;
let wallAtUpdate = performance.now();
let lastInputT = 0;
let finishedShown = false;
let doneTimer = 0;

/** Ride time "now", interpolated between fixed ticks with the wall clock. */
const rideNow = (): number => ride.time + acc + (performance.now() - wallAtUpdate) / 1000;

/** Builds a new ride and scene. autopilot: attract / demo rider (attract hides the cue). */
function startRide(autopilot: boolean, avatar: Avatar): void {
  rs?.scene.dispose();
  ride = new RideSim(config(), parser, autopilot ? {} : { proMode: pro, dailyTokenId: daily.id });
  bot = autopilot ? new Autopilot(book, parser, Math.random) : null;
  rs = new RampScene(engine, ride, avatar, sprites, !autopilot || demo);
  acc = 0;
  lastInputT = 0;
  finishedShown = false;
  layout();
}

const refreshHints = (): void => {
  if (!pro) hud.showHints(pickHints(feasibleHints(book, parser, ride), 3, Math.random));
};

const release = (nodes: number[]): void => {
  if (screen !== 'ride' || bot || ride.finished) return;
  const t = Math.max(rideNow(), lastInputT, ride.time);
  lastInputT = t;
  ride.addInput({ t, nodes });
};
const pad = new SwipePad(byId('pad') as HTMLCanvasElement, release);
const statCard = new StatCard(() => go('attract'));

// ── Screens ──
interface Overlay { root: HTMLElement; dispose?: () => void }
let overlay: Overlay | null = null;
let picker: AvatarPicker | null = null;
let tuning: TuningPanel | null = null;
let idle = 0;

function kickIdle(): void {
  clearTimeout(idle);
  // Menus fall back to attract after 20 s without a touch.
  if (screen === 'avatar' || screen === 'trickBook') idle = window.setTimeout(() => go('attract'), 20_000);
}
addEventListener('pointerdown', kickIdle, true);
addEventListener('keydown', kickIdle, true);

function setOverlay(o: Overlay | null): void {
  if (overlay) {
    if (overlay.dispose) overlay.dispose();
    else overlay.root.remove();
  }
  overlay = o;
  picker = null;
  if (o) document.body.append(o.root);
}

const attractAvatar = (): Avatar => avatarOf(PRESETS[Math.floor(Math.random() * PRESETS.length)]);

function go(s: Screen, opts: { pro?: boolean } = {}): void {
  screen = s;
  if (opts.pro !== undefined) pro = opts.pro;
  clearTimeout(doneTimer);
  closeTuning();
  statCard.hide();
  pad.clear();
  rideUi.hidden = s !== 'ride';
  switch (s) {
    case 'attract':
      setOverlay(new AttractScreen(daily.name, {
        start: (p) => go('avatar', { pro: p }),
        trickBook: () => go('trickBook'),
        nextStyle: () => setStyle(nextStyle(Palette.style)),
        tuning: openTuning,
      }));
      startRide(true, attractAvatar());
      break;
    case 'avatar': {
      const p = new AvatarPicker(settings.avatar, sprites, (a) => {
        settings.avatar = a;
        saveSettings(settings);
        go('ride');
      }, () => go('attract'));
      setOverlay(p);
      picker = p;
      break;
    }
    case 'ride':
      setOverlay(null);
      hud.reset();
      hud.setPro(pro);
      startRide(demo, settings.avatar);
      refreshHints();
      break;
    case 'trickBook':
      setOverlay(new TrickBookScreen(book, parser, () => go('attract')));
      break;
  }
  kickIdle();
}

function setStyle(s: ArtStyle): void {
  settings.style = s;
  saveSettings(settings);
  applyStyle(s);
  // Like Flutter's style-keyed screens: rebuild so nothing keeps the old palette.
  const keepTuning = tuning !== null;
  go(screen === 'ride' ? 'ride' : 'attract');
  if (keepTuning) openTuning();
}

function openTuning(): void {
  closeTuning();
  tuning = new TuningPanel(settings.tuning, (t) => {
    settings.tuning = t;
    saveSettings(settings);
  }, setStyle, closeTuning);
  document.body.append(tuning.root);
}

function closeTuning(): void {
  tuning?.root.remove();
  tuning = null;
}

addEventListener('keydown', (e) => {
  if (e.metaKey || e.ctrlKey || e.altKey) return;
  const enter = e.code === 'Space' || e.code === 'Enter' || e.code === 'NumpadEnter';
  if (screen === 'attract' && enter && !tuning) {
    e.preventDefault();
    go('avatar', { pro: false });
  } else if (screen === 'avatar' && enter) {
    e.preventDefault();
    picker?.finish();
  } else if ((screen === 'trickBook' || screen === 'avatar') && e.code === 'Escape') {
    go('attract');
  } else if (screen === 'ride') {
    if (statCard.visible) {
      if (enter) {
        e.preventDefault();
        statCard.tryDone();
      }
    } else if (pad.key(e)) e.preventDefault();
  }
});

/**
 * Layout from ride_screen.dart: pad bottom-right, hint strip bottom-left, ramp in
 * the rest. Portrait (web only): ramp on top, hints, then the pad full width.
 * Attract (attract_screen.dart): the ramp fills the screen below the title.
 */
function layout(): void {
  engine.resize();
  const w = innerWidth;
  const h = innerHeight;
  if (!rs) return;
  if (screen !== 'ride') {
    rs.fit({ left: 0, top: h * 0.12, width: w, height: h * 0.88 });
    return;
  }
  const portrait = h > w;
  const top = 64;
  const padEl = byId('pad');
  const hints = byId('hints');
  const popup = byId('popup');
  let world: WorldRect;
  if (portrait) {
    const hintH = pro ? 8 : 92;
    const grid = Math.min(w - 32, Math.max(h * 0.36, 200));
    padEl.style.width = padEl.style.height = `${grid}px`;
    padEl.style.right = `${(w - grid) / 2}px`;
    Object.assign(hints.style, { left: '12px', right: '12px', bottom: `${grid + 24}px`, height: `${hintH - 12}px` });
    world = { left: 12, top: top + 20, width: w - 24, height: h - top - 20 - grid - 24 - hintH };
  } else {
    const hintH = pro ? 16 : 112;
    const grid = Math.max(h * 0.45, 220);
    padEl.style.width = padEl.style.height = `${grid}px`;
    padEl.style.right = '16px';
    Object.assign(hints.style, { left: '20px', right: `${grid + 40}px`, bottom: '12px', height: `${hintH - 20}px` });
    world = { left: 12, top, width: w - grid - 36, height: h - top - hintH };
  }
  Object.assign(popup.style, { left: `${world.left}px`, right: 'auto', width: `${world.width}px`, top: `${world.top + 8}px` });
  rs.fit(world);
}
addEventListener('resize', layout);

if (demo || params.has('ride') || params.has('pro')) go('ride', { pro: params.has('pro') && !demo });
else go('attract');

let frames = 0;
let fpsT = performance.now();
let firstFrame = true;
engine.runRenderLoop(() => {
  const now = performance.now();
  acc += Math.min((now - wallAtUpdate) / 1000, 0.1);
  wallAtUpdate = now;
  // Pixel style: render the game at 1/n resolution, scaled up without smoothing.
  const scaling = Palette.spec.pixel > 1 ? Palette.spec.pixel : 1 / (devicePixelRatio || 1);
  if (engine.getHardwareScalingLevel() !== scaling) {
    engine.setHardwareScalingLevel(scaling);
    layout();
  }
  while (acc >= ride.config.dt) {
    acc -= ride.config.dt;
    bot?.tick(ride);
    ride.step();
    for (const e of ride.drainEvents()) {
      if (screen !== 'ride') continue;
      hud.onEvent(e);
      if (e.type === 'landed') refreshHints();
    }
  }
  if (ride.finished && !finishedShown) {
    finishedShown = true;
    if (screen !== 'ride' || demo) {
      // Attract loop shows off a different character every run.
      startRide(true, screen === 'ride' ? settings.avatar : attractAvatar());
    } else {
      statCard.show(ride.stats, ride.bailReason !== null);
      doneTimer = window.setTimeout(() => go('attract'), 10_000);
    }
  }
  if (rs) {
    rs.sync();
    rs.scene.render();
  }
  if (screen === 'ride') hud.update(ride.stats.score, ride.stats.streak, ride.speed);
  if (firstFrame && rs?.scene.isReady()) {
    // First frame with every mesh drawn (shaders compiled), not just the clear colour.
    firstFrame = false;
    const ms = Math.round(performance.now() - t0);
    (window as unknown as { __firstFrameMs: number }).__firstFrameMs = performance.now();
    console.info(`first frame ${ms} ms after script start, ${Math.round(performance.now())} ms after navigation`);
    // Sprites after the first frame, so they never delay it.
    void loadSprites().then((s) => {
      sprites = s;
      rs?.setSprites(s);
      picker?.setSprites(s);
    });
  }
  frames++;
  if (now - fpsT >= 1000) {
    if (debug) hud.showFps(`${Math.round((frames * 1000) / (now - fpsT))} fps`);
    frames = 0;
    fpsT = now;
  }
});
