// Babylon scene: orthographic side view of the U-ramp (WorldView.fit in rattle_game.dart),
// flat emissive shapes on the z = 0 plane, skater sprite, cue ring and the bar's logo.
// Follows the active art style (ui/palette.ts): colours, comic ink outlines, neon halo,
// screen-space backdrop (style_paint.dart BackdropComponent) and pixelation.
import { Engine } from '@babylonjs/core/Engines/engine';
import { Scene } from '@babylonjs/core/scene';
import { FreeCamera } from '@babylonjs/core/Cameras/freeCamera';
import { Camera } from '@babylonjs/core/Cameras/camera';
import { Color3, Color4 } from '@babylonjs/core/Maths/math.color';
import { Vector3 } from '@babylonjs/core/Maths/math.vector';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { DynamicTexture } from '@babylonjs/core/Materials/Textures/dynamicTexture';
import { Layer } from '@babylonjs/core/Layers/layer';
import { CreateRibbon } from '@babylonjs/core/Meshes/Builders/ribbonBuilder';
import { CreateDisc } from '@babylonjs/core/Meshes/Builders/discBuilder';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';
// Bundle the StandardMaterial and layer shaders up front: saves lazy-load round trips before the first frame.
import '@babylonjs/core/Shaders/default.vertex';
import '@babylonjs/core/Shaders/default.fragment';
import '@babylonjs/core/Shaders/layer.vertex';
import '@babylonjs/core/Shaders/layer.fragment';

import type { Avatar } from '../rules/avatar';
import type { RideSim } from '../rules/ride-sim';
import { worldBounds } from '../rules/ride-sim';
import { pal, rgb01, Palette } from '../ui/palette';
import type { AvatarSprites } from '../ui/sprites';
import { paintBackdrop } from '../ui/backdrop';
import { CUE_SPREAD, CUE_TARGET, paintCue } from '../ui/cue-paint';
import { SkaterSprite } from './skater';
import { SpritePlane } from './sprite-plane';

const flat = (scene: Scene, css: string, alpha = 1): StandardMaterial => {
  const m = new StandardMaterial(css, scene);
  m.disableLighting = true;
  m.emissiveColor = Color3.FromArray(rgb01(css));
  m.alpha = alpha;
  m.backFaceCulling = false;
  return m;
};

/** Screen-space rectangle (CSS px) the ramp should fit into. */
export interface WorldRect { left: number; top: number; width: number; height: number }

/** Offset a polyline along its normal by d (both sides → a ribbon of width 2d). */
function band(pts: Vector3[], d: number, z: number): { up: Vector3[]; dn: Vector3[] } {
  const up: Vector3[] = [];
  const dn: Vector3[] = [];
  pts.forEach((p, i) => {
    const a = pts[Math.max(0, i - 1)];
    const b = pts[Math.min(pts.length - 1, i + 1)];
    const t = b.subtract(a).normalize();
    const n = new Vector3(-t.y, t.x, 0).scale(d);
    up.push(p.add(n).addInPlaceFromFloats(0, 0, z));
    dn.push(p.subtract(n).addInPlaceFromFloats(0, 0, z));
  });
  return { up, dn };
}

export class RampScene {
  readonly scene: Scene;
  private readonly camera: FreeCamera;
  private readonly skater: SkaterSprite;
  private readonly cue: SpritePlane;
  private readonly backdrop: DynamicTexture;
  private backdropSize = '';

  /** showCue false = attract autopilot (cue_component.dart hides it). */
  constructor(readonly engine: Engine, private readonly ride: RideSim, avatar: Avatar, sprites: AvatarSprites, private readonly showCue = true) {
    const c = pal();
    const scene = (this.scene = new Scene(engine));
    scene.clearColor = Color4.FromArray([...rgb01(c.night), 1]);
    scene.skipPointerMovePicking = true;

    const cam = (this.camera = new FreeCamera('cam', new Vector3(0, 0, -10), scene));
    cam.setTarget(new Vector3(0, 0, 0));
    cam.mode = Camera.ORTHOGRAPHIC_CAMERA;
    cam.minZ = 0.1;

    // Screen-space backdrop drawn with Canvas 2D, redrawn on resize.
    this.backdrop = new DynamicTexture('backdrop', { width: 4, height: 4 }, scene, false);
    const layer = new Layer('backdrop', null, scene, true);
    layer.texture = this.backdrop;

    this.buildRamp();
    this.skater = new SkaterSprite(scene, avatar, sprites);

    // Cue ring around the coping it is heading to.
    const R = CUE_TARGET + CUE_SPREAD + 0.2;
    this.cue = new SpritePlane(scene, 'cue', { left: -R, right: R, bottom: -R, top: R }, 512, -0.03);
    this.cue.visible = false;
  }

  setSprites(sprites: AvatarSprites): void { this.skater.setSprites(sprites); }

  private buildRamp(): void {
    const { scene, ride } = this;
    const c = pal();
    const r = ride.ramp;
    const deck = r.copingX + 1.6;
    const h = r.copingHeight;
    const top: Vector3[] = [new Vector3(-deck, h, 0)];
    const samples = 160;
    for (let i = 0; i <= samples; i++) {
      const p = r.point((r.length * i) / samples);
      top.push(new Vector3(p.x, p.y, 0));
    }
    top.push(new Vector3(deck, h, 0));
    const bottom = top.map((p) => new Vector3(p.x, -2, 0));
    CreateRibbon('rampFill', { pathArray: [top, bottom], sideOrientation: 2 }, scene).material = flat(scene, c.rampFill);

    // Edge stroke 0.07 (ramp_component.dart); comic adds ink 0.08 under it, neon a halo.
    const ribbon = (name: string, half: number, z: number, css: string, alpha = 1): void => {
      const b = band(top, half, z);
      CreateRibbon(name, { pathArray: [b.up, b.dn], sideOrientation: 2 }, scene).material = flat(scene, css, alpha);
    };
    if (c.ink !== null) ribbon('rampInk', (0.07 + 0.08) / 2, -0.005, c.ink);
    else if (c.glow) ribbon('rampGlow', (0.07 * 2.2) / 2, -0.005, c.rampEdge, 0.3);
    ribbon('rampEdge', 0.035, -0.01, c.rampEdge);

    for (const side of [-1, 1]) {
      const p = r.coping(side);
      if (c.ink !== null) {
        const ink = CreateDisc(`copingInk${side}`, { radius: 0.09 + 0.04, tessellation: 24 }, scene);
        ink.material = flat(scene, c.ink);
        ink.position.set(p.x, p.y, -0.015);
      }
      const d = CreateDisc(`coping${side}`, { radius: 0.09, tessellation: 24 }, scene);
      d.material = flat(scene, c.coping);
      d.position.set(p.x, p.y, -0.02);
    }

    // Logo on the flat face: "U CHŘESTÝŠE", 0.42 m type, top edge 0.35 m below the flat.
    const lw = 4.2, lh = 0.7, ppm = 160;
    const tex = new DynamicTexture('logo', { width: lw * ppm, height: lh * ppm }, scene, true);
    tex.hasAlpha = true;
    const g = tex.getContext() as CanvasRenderingContext2D;
    g.clearRect(0, 0, lw * ppm, lh * ppm);
    g.font = `900 ${0.42 * ppm}px ${getComputedStyle(document.body).fontFamily || 'sans-serif'}`;
    g.textAlign = 'center';
    g.textBaseline = 'top';
    g.fillStyle = c.coping;
    if ('letterSpacing' in g) (g as unknown as { letterSpacing: string }).letterSpacing = `${0.08 * ppm}px`;
    g.fillText('U CHŘESTÝŠE', (lw * ppm) / 2, 0.02 * ppm);
    tex.update();
    const logo = CreatePlane('logo', { width: lw, height: lh }, scene);
    const m = new StandardMaterial('logoMat', scene);
    m.disableLighting = true;
    m.emissiveColor = Color3.White();
    m.diffuseTexture = tex;
    m.useAlphaFromDiffuseTexture = true;
    logo.material = m;
    logo.position.set(0, -0.35 - lh / 2, -0.005);
  }

  /** Fit the world into a CSS-pixel rectangle of the canvas (WorldView.fit). */
  fit(rect: WorldRect): void {
    const canvas = this.engine.getRenderingCanvas();
    const cw = canvas?.clientWidth ?? 0;
    const ch = canvas?.clientHeight ?? 0;
    if (cw < 1 || ch < 1) return;
    const b = worldBounds(this.ride.config, this.ride.ramp);
    const hWorld = b.top - b.bottom;
    const k = Math.min(rect.width / b.width, rect.height / hWorld); // px per metre
    const cx = 0;
    const cy = b.bottom + hWorld / 2;
    const ox = (rect.left + rect.width / 2 - cw / 2) / k;
    const oy = (rect.top + rect.height / 2 - ch / 2) / k;
    const halfW = cw / 2 / k;
    const halfH = ch / 2 / k;
    const cam = this.camera;
    cam.orthoLeft = cx - ox - halfW;
    cam.orthoRight = cx - ox + halfW;
    cam.orthoTop = cy + oy + halfH;
    cam.orthoBottom = cy + oy - halfH;
    this.redrawBackdrop(cw, ch);
  }

  private redrawBackdrop(cw: number, ch: number): void {
    const key = `${cw}x${ch}:${Palette.style}`;
    if (key === this.backdropSize) return;
    this.backdropSize = key;
    // Backdrop at CSS resolution (pixel style is downscaled anyway).
    const w = Math.max(4, Math.round(cw)), h = Math.max(4, Math.round(ch));
    this.backdrop.scaleTo(w, h);
    const g = this.backdrop.getContext() as CanvasRenderingContext2D;
    paintBackdrop(g, w, h);
    this.backdrop.update();
  }

  /** Copy sim state into the scene for this frame. */
  sync(): void {
    const ride = this.ride;
    this.skater.sync(ride.pose);

    // Cue (cue_component.dart): only while rolling towards the edge, before a release is judged.
    const tte = ride.timeToEdge;
    const lead = ride.config.cueLead;
    const show = this.showCue && (ride.phase === 'rolling' || ride.phase === 'dropIn') && tte <= lead && !ride.hasAttempt;
    this.cue.visible = show;
    if (!show) return;
    const c = pal();
    const at = ride.ramp.coping(ride.edgeSide);
    const k = Math.min(1, Math.max(0, tte / lead));
    const css = Math.abs(tte) <= ride.perfectWindow ? c.perfect : Math.abs(tte) <= ride.goodWindow ? c.good : c.skater;
    this.cue.root.position.set(at.x, at.y, -0.03);
    this.cue.draw((g) => paintCue(g, k, css));
  }
}
