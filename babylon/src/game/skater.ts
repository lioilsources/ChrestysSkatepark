// Skater in the Babylon scene: a plane at the board contact point, rotated to the
// pose angle, whose DynamicTexture is redrawn every frame by ui/skater-paint.ts
// (the Canvas 2D port of skater_component.dart). Sprites on planes, as the plan says.
import type { Scene } from '@babylonjs/core/scene';
import { Color3 } from '@babylonjs/core/Maths/math.color';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { DynamicTexture } from '@babylonjs/core/Materials/Textures/dynamicTexture';
import { TransformNode } from '@babylonjs/core/Meshes/transformNode';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';

import type { Avatar } from '../rules/avatar';
import type { SkaterPose } from '../rules/ride-sim';
import { paintSkater } from '../ui/skater-paint';

/** Skater-local box the rig can reach (bail, spread grab, split): metres around the contact point. */
const BOX = { left: -1.6, right: 1.6, bottom: -0.9, top: 2.5 };

export class SkaterSprite {
  private readonly root: TransformNode;
  private readonly tex: DynamicTexture;
  private readonly ppm: number;

  constructor(scene: Scene, private readonly avatar: Avatar, texSize = 512) {
    const w = BOX.right - BOX.left;
    const h = BOX.top - BOX.bottom;
    this.ppm = texSize / Math.max(w, h);
    this.root = new TransformNode('skater', scene);
    const plane = CreatePlane('skaterPlane', { width: w, height: h }, scene);
    plane.parent = this.root;
    plane.position.set((BOX.left + BOX.right) / 2, (BOX.bottom + BOX.top) / 2, 0);
    this.tex = new DynamicTexture('skaterTex', { width: Math.round(w * this.ppm), height: Math.round(h * this.ppm) }, scene, true);
    this.tex.hasAlpha = true;
    const m = new StandardMaterial('skaterMat', scene);
    m.disableLighting = true;
    m.emissiveColor = Color3.White();
    m.diffuseTexture = this.tex;
    m.useAlphaFromDiffuseTexture = true;
    m.backFaceCulling = false;
    plane.material = m;
  }

  sync(p: SkaterPose): void {
    this.root.position.set(p.x, p.y, -0.05);
    this.root.rotation.z = p.angle;
    const g = this.tex.getContext() as CanvasRenderingContext2D;
    const size = this.tex.getSize();
    g.setTransform(1, 0, 0, 1, 0, 0);
    g.clearRect(0, 0, size.width, size.height);
    // y-up metres → texture pixels, origin at the contact point.
    g.setTransform(this.ppm, 0, 0, -this.ppm, -BOX.left * this.ppm, BOX.top * this.ppm);
    paintSkater(g, p, this.avatar);
    this.tex.update();
  }
}
