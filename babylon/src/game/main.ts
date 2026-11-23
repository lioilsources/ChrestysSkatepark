// Entry point (rattle_game.dart + ride_screen.dart): steps the RideSim at its fixed
// rate, maps wall-clock releases to ride time (RattleGame.release), renders the
// Babylon scene and drives the DOM HUD, hint strip and stat card.
import { Engine } from '@babylonjs/core/Engines/engine';

import { Autopilot } from '../rules/autopilot';
import { initialAvatar } from '../rules/avatar';
import { feasibleHints, pickHints } from '../rules/hints';
import { defaultConfig } from '../rules/ride-config';
import { RideSim } from '../rules/ride-sim';
import { dailyTokenFor, defaultBook } from '../rules/trick-defs';
import { TrickParser } from '../rules/trick-parser';
import { byId, Hud } from '../ui/hud';
import { StatCard } from '../ui/stat-card';
import { SwipePad } from '../ui/swipe-pad';
import { RampScene } from './scene';
import '../ui/style.css';

const t0 = performance.now();
const params = new URLSearchParams(location.search);
const debug = params.has('debug');
const pro = params.has('pro');
/** ?demo: the attract-mode autopilot rides; touch input is ignored, rides loop. */
const demo = params.has('demo');

const canvas = document.getElementById('game') as HTMLCanvasElement;
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: false, antialias: true }, true);
const config = defaultConfig();
const book = defaultBook();
const parser = new TrickParser(book);
const daily = dailyTokenFor(book, new Date());
const avatar = initialAvatar();
const hud = new Hud(daily.name, pro);
const makeRide = (): RideSim => new RideSim(config, parser, { proMode: pro, dailyTokenId: daily.id });

let ride = makeRide();
let rs = new RampScene(engine, ride, avatar);
let acc = 0;
let wallAtUpdate = performance.now();
let lastInputT = 0;
let bot = demo ? new Autopilot(book, parser, Math.random) : null;

/** Ride time "now", interpolated between fixed ticks with the wall clock. */
const rideNow = (): number => ride.time + acc + (performance.now() - wallAtUpdate) / 1000;

const refreshHints = (): void => {
  if (!pro) hud.showHints(pickHints(feasibleHints(book, parser, ride), 3, Math.random));
};



function newRide(): void {
  statCard.hide();
  pad.clear();
  rs.scene.dispose();
  ride = makeRide();
  rs = new RampScene(engine, ride, avatar);
  acc = 0;
  lastInputT = 0;
  if (demo) bot = new Autopilot(book, parser, Math.random);
  hud.reset();
  refreshHints();
  layout();
}

const release = (nodes: number[]): void => {
  if (ride.finished || demo) return;
  const t = Math.max(rideNow(), lastInputT, ride.time);
  lastInputT = t;
  ride.addInput({ t, nodes });
};
const pad = new SwipePad(byId('pad') as HTMLCanvasElement, release);
const statCard = new StatCard(() => newRide());

addEventListener('keydown', (e) => {
  if (statCard.visible) {
    if (e.code === 'Space' || e.code === 'Enter' || e.code === 'NumpadEnter') {
      e.preventDefault();
      statCard.tryDone();
    }
    return;
  }
  if (pad.key(e)) e.preventDefault();
});

/**
 * Layout from ride_screen.dart: pad bottom-right, hint strip bottom-left, ramp in
 * the rest. Portrait (web only): ramp on top, hints, then the pad full width.
 */
function layout(): void {
  engine.resize();
  const w = innerWidth;
  const h = innerHeight;
  const portrait = h > w;
  const top = 64;
  const padEl = byId('pad');
  const hints = byId('hints');
  const popup = byId('popup');
  let world;
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
refreshHints();
layout();

let frames = 0;
let fpsT = performance.now();
let firstFrame = true;
engine.runRenderLoop(() => {
  const now = performance.now();
  acc += Math.min((now - wallAtUpdate) / 1000, 0.1);
  wallAtUpdate = now;
  while (acc >= config.dt) {
    acc -= config.dt;
    bot?.tick(ride);
    ride.step();
    for (const e of ride.drainEvents()) {
      hud.onEvent(e);
      if (e.type === 'landed') refreshHints();
      if (e.type === 'finished') {
        if (demo) newRide();
        else statCard.show(ride.stats, ride.bailReason !== null);
      }
    }
  }
  rs.sync();
  rs.scene.render();
  hud.update(ride.stats.score, ride.stats.streak, ride.speed);
  if (firstFrame && rs.scene.isReady()) {
    // First frame with every mesh drawn (shaders compiled), not just the clear colour.
    firstFrame = false;
    const ms = Math.round(performance.now() - t0);
    (window as unknown as { __firstFrameMs: number }).__firstFrameMs = performance.now();
    console.info(`first frame ${ms} ms after script start, ${Math.round(performance.now())} ms after navigation`);
  }
  frames++;
  if (now - fpsT >= 1000) {
    if (debug) hud.showFps(`${Math.round((frames * 1000) / (now - fpsT))} fps`);
    frames = 0;
    fpsT = now;
  }
});
