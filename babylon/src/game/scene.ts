// Babylon scene: orthographic side view of the U-ramp (same framing as WorldView.fit
// in rattle_game.dart), flat emissive shapes on the z = 0 plane, skater rig and cue ring.
import { Engine } from '@babylonjs/core/Engines/engine';
import { Scene } from '@babylonjs/core/scene';
import { FreeCamera } from '@babylonjs/core/Cameras/freeCamera';
import { Camera } from '@babylonjs/core/Cameras/camera';
import { Color3, Color4 } from '@babylonjs/core/Maths/math.color';
import { Vector3 } from '@babylonjs/core/Maths/math.vector';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { TransformNode } from '@babylonjs/core/Meshes/transformNode';
import type { Mesh } from '@babylonjs/core/Meshes/mesh';
import { CreateRibbon } from '@babylonjs/core/Meshes/Builders/ribbonBuilder';
import { CreateDisc } from '@babylonjs/core/Meshes/Builders/discBuilder';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';
import { CreateTorus } from '@babylonjs/core/Meshes/Builders/torusBuilder';
// Bundle the StandardMaterial shaders up front: saves a lazy-load round trip before the first frame.
import '@babylonjs/core/Shaders/default.vertex';
import '@babylonjs/core/Shaders/default.fragment';

import type { SpikeRide } from '../rules/spike-ride';
import { worldBounds } from '../rules/spike-ride';
import { NEON } from '../ui/palette';

const flat = (scene: Scene, hex: string, alpha = 1): StandardMaterial => {
  const m = new StandardMaterial(hex, scene);
  m.disableLighting = true;
  m.emissiveColor = Color3.FromHexString(hex);
  m.alpha = alpha;
  m.backFaceCulling = false;
  return m;
};

/** Screen-space rectangle (CSS px) the ramp should fit into. */
export interface WorldRect { left: number; top: number; width: number; height: number }

export class RampScene {
  readonly scene: Scene;
  private readonly camera: FreeCamera;
  private readonly skater: TransformNode;
  private readonly body: TransformNode;
  private readonly torso: Mesh;
  private readonly cueTarget: Mesh;
  private readonly cueRing: Mesh;
  private readonly cueMat: StandardMaterial;

  constructor(readonly engine: Engine, private readonly ride: SpikeRide) {
    const scene = (this.scene = new Scene(engine));
    scene.clearColor = Color4.FromHexString(`${NEON.night}FF`);
    scene.skipPointerMovePicking = true;

    const cam = (this.camera = new FreeCamera('cam', new Vector3(0, 0, -10), scene));
    cam.setTarget(new Vector3(0, 0, 0));
    cam.mode = Camera.ORTHOGRAPHIC_CAMERA;
    cam.minZ = 0.1;

    this.buildRamp();

    // Skater rig: root at the board contact point, local +y = up for the skater.
    this.skater = new TransformNode('skater', scene);
    const board = CreatePlane('board', { width: 0.82, height: 0.07 }, scene);
    board.material = flat(scene, NEON.board);
    board.parent = this.skater;
    board.position.set(0, 0.1, -0.02);
    this.body = new TransformNode('body', scene);
    this.body.parent = this.skater;
    this.torso = CreatePlane('torso', { width: 0.26, height: 1 }, scene);
    this.torso.material = flat(scene, NEON.skater);
    this.torso.parent = this.body;
    const head = CreateDisc('head', { radius: 0.17, tessellation: 24 }, scene);
    head.material = flat(scene, NEON.skater);
    head.parent = this.body;
    head.position.set(0.04, 1.32, -0.01);

    // Cue: a ring that shrinks onto the coping (cue_component.dart).
    this.cueTarget = CreateTorus('cueTarget', { diameter: 0.68, thickness: 0.05, tessellation: 48 }, scene);
    this.cueTarget.rotation.x = Math.PI / 2;
    this.cueTarget.material = flat(scene, NEON.coping, 0.9);
    this.cueRing = CreateTorus('cueRing', { diameter: 1, thickness: 0.06, tessellation: 48 }, scene);
    this.cueRing.rotation.x = Math.PI / 2;
    this.cueMat = flat(scene, NEON.skater);
    this.cueRing.material = this.cueMat;
  }

  private buildRamp(): void {
    const { scene, ride } = this;
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
    const fill = CreateRibbon('rampFill', { pathArray: [top, bottom], sideOrientation: 2 }, scene);
    fill.material = flat(scene, NEON.rampFill);

    // Edge: a thin ribbon offset along the normal of the surface polyline.
    const w = 0.035;
    const up: Vector3[] = [];
    const dn: Vector3[] = [];
    top.forEach((p, i) => {
      const a = top[Math.max(0, i - 1)];
      const b = top[Math.min(top.length - 1, i + 1)];
      const t = b.subtract(a).normalize();
      const n = new Vector3(-t.y, t.x, 0).scale(w);
      up.push(p.add(n).addInPlaceFromFloats(0, 0, -0.01));
      dn.push(p.subtract(n).addInPlaceFromFloats(0, 0, -0.01));
    });
    const edge = CreateRibbon('rampEdge', { pathArray: [up, dn], sideOrientation: 2 }, scene);
    edge.material = flat(scene, NEON.rampEdge);

    for (const side of [-1, 1]) {
      const c = r.coping(side);
      const d = CreateDisc(`coping${side}`, { radius: 0.09, tessellation: 20 }, scene);
      d.material = flat(scene, NEON.coping);
      d.position.set(c.x, c.y, -0.02);
    }
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
    // World point at the rect centre.
    const cx = 0;
    const cy = b.bottom + hWorld / 2;
    // Offset of the rect centre from the canvas centre, in metres.
    const ox = (rect.left + rect.width / 2 - cw / 2) / k;
    const oy = (rect.top + rect.height / 2 - ch / 2) / k;
    const halfW = cw / 2 / k;
    const halfH = ch / 2 / k;
    const cam = this.camera;
    cam.orthoLeft = cx - ox - halfW;
    cam.orthoRight = cx - ox + halfW;
    cam.orthoTop = cy + oy + halfH;
    cam.orthoBottom = cy + oy - halfH;
  }

  /** Copy sim state into the scene for this frame. */
  sync(): void {
    const ride = this.ride;
    const p = ride.pose;
    this.skater.position.set(p.x, p.y, -0.05);
    this.skater.rotation.z = p.angle;
    // Spin = horizontal squash of the rig; facing sign mirrors it.
    this.skater.scaling.x = Math.abs(p.facing) < 0.05 ? 0.05 * Math.sign(p.facing || 1) : p.facing;
    const tall = 1 - 0.45 * p.crouch;
    this.torso.scaling.y = tall;
    this.torso.position.set(0, 0.14 + tall / 2, -0.01);
    this.body.rotation.z = -p.bail * 1.4;

    // Cue ring (hidden while airborne or once a release is judged).
    const tte = ride.timeToEdge;
    const lead = ride.config.cueLead;
    const showCue = (ride.phase === 'rolling' || ride.phase === 'dropIn') && tte <= lead && tte >= -ride.lateWindow;
    this.cueTarget.isVisible = this.cueRing.isVisible = showCue;
    if (showCue) {
      const c = ride.ramp.coping(ride.dir);
      const k = Math.min(1, Math.max(0, tte / lead));
      this.cueTarget.position.set(c.x, c.y, -0.03);
      this.cueRing.position.set(c.x, c.y, -0.03);
      const d = 0.68 + 2 * 1.9 * k;
      this.cueRing.scaling.set(d, 1, d);
      const hex = Math.abs(tte) <= ride.perfectWindow ? NEON.perfect : Math.abs(tte) <= ride.goodWindow ? NEON.good : NEON.skater;
      this.cueMat.emissiveColor = Color3.FromHexString(hex);
      this.cueMat.alpha = (1 - k) * 0.8 + 0.2;
    }
  }
}
