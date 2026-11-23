// Entry point: steps the RideSim at the Dart sim's fixed rate, maps wall-clock
// releases to ride time (RattleGame.release) and renders the Babylon scene.
import { Engine } from '@babylonjs/core/Engines/engine';

import { defaultConfig } from '../rules/ride-config';
import { RideSim } from '../rules/ride-sim';
import { dailyTokenFor, defaultBook } from '../rules/trick-defs';
import { TrickParser } from '../rules/trick-parser';
import { Hud } from '../ui/hud';
import { SwipePad } from '../ui/swipe-pad';
import { RampScene } from './scene';
import '../ui/style.css';

const t0 = performance.now();
const params = new URLSearchParams(location.search);
const debug = params.has('debug');

const canvas = document.getElementById('game') as HTMLCanvasElement;
const engine = new Engine(canvas, true, { preserveDrawingBuffer: false, stencil: false, antialias: true }, true);
const config = defaultConfig();
const book = defaultBook();
const parser = new TrickParser(book);
const daily = dailyTokenFor(book, new Date());
const hud = new Hud(daily.name);
const makeRide = (): RideSim => new RideSim(config, parser, { dailyTokenId: daily.id });

let ride = makeRide();
let rs = new RampScene(engine, ride);
let acc = 0;
let wallAtUpdate = performance.now();
let lastInputT = 0;

/** Ride time "now", interpolated between fixed ticks with the wall clock. */
const rideNow = (): number => ride.time + acc + (performance.now() - wallAtUpdate) / 1000;

function newRide(): void {
  rs.scene.dispose();
  ride = makeRide();
  rs = new RampScene(engine, ride);
  acc = 0;
  lastInputT = 0;
  layout();
}

new SwipePad(document.getElementById('pad') as HTMLCanvasElement, (nodes) => {
  if (ride.finished) { newRide(); return; }
  const t = Math.max(rideNow(), lastInputT, ride.time);
  lastInputT = t;
  ride.addInput({ t, nodes });
});
canvas.addEventListener('pointerdown', () => { if (ride.finished) newRide(); });

/** Same split as ride_screen.dart: pad bottom-right, ramp in the rest. */
function layout(): void {
  engine.resize();
  const w = innerWidth;
  const h = innerHeight;
  const portrait = h > w;
  const grid = portrait ? Math.min(w - 32, Math.max(h * 0.4, 220)) : Math.max(h * 0.45, 220);
  const pad = document.getElementById('pad') as HTMLCanvasElement;
  pad.style.width = pad.style.height = `${grid}px`;
  const top = 64;
  rs.fit(portrait
    ? { left: 12, top, width: w - 24, height: h - top - grid - 32 }
    : { left: 12, top, width: w - grid - 36, height: h - top - 16 });
}
addEventListener('resize', layout);
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
    ride.step();
    for (const e of ride.drainEvents()) hud.onEvent(e);
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
