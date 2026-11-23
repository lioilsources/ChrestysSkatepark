// A plane in the z = 0 world whose DynamicTexture is drawn with Canvas 2D in
// local metres (y up). Used for the skater rig and the cue ring.
import type { Scene } from '@babylonjs/core/scene';
import { Color3 } from '@babylonjs/core/Maths/math.color';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { DynamicTexture } from '@babylonjs/core/Materials/Textures/dynamicTexture';
import { TransformNode } from '@babylonjs/core/Meshes/transformNode';
import type { Mesh } from '@babylonjs/core/Meshes/mesh';
import { CreatePlane } from '@babylonjs/core/Meshes/Builders/planeBuilder';

export interface Box { left: number; right: number; bottom: number; top: number }

export class SpritePlane {
  readonly root: TransformNode;
  private readonly plane: Mesh;
  private readonly tex: DynamicTexture;
  private readonly ppm: number;

  constructor(scene: Scene, name: string, private readonly box: Box, texSize: number, z: number) {
    const w = box.right - box.left;
    const h = box.top - box.bottom;
    this.ppm = texSize / Math.max(w, h);
    this.root = new TransformNode(name, scene);
    this.root.position.z = z;
    this.plane = CreatePlane(`${name}Plane`, { width: w, height: h }, scene);
    this.plane.parent = this.root;
    this.plane.position.set((box.left + box.right) / 2, (box.bottom + box.top) / 2, 0);
    this.tex = new DynamicTexture(`${name}Tex`, { width: Math.round(w * this.ppm), height: Math.round(h * this.ppm) }, scene, true);
    this.tex.hasAlpha = true;
    const m = new StandardMaterial(`${name}Mat`, scene);
    m.disableLighting = true;
    m.emissiveColor = Color3.White();
    m.diffuseTexture = this.tex;
    m.useAlphaFromDiffuseTexture = true;
    m.backFaceCulling = false;
    this.plane.material = m;
    this.tex.update(); // empty upload, so a hidden plane doesn't keep scene.isReady() false
  }

  set visible(v: boolean) { this.plane.isVisible = v; }

  /** Clears the texture and calls paint with a y-up metre transform at the local origin. */
  draw(paint: (g: CanvasRenderingContext2D) => void): void {
    const g = this.tex.getContext() as CanvasRenderingContext2D;
    const size = this.tex.getSize();
    g.setTransform(1, 0, 0, 1, 0, 0);
    g.clearRect(0, 0, size.width, size.height);
    g.setTransform(this.ppm, 0, 0, -this.ppm, -this.box.left * this.ppm, this.box.top * this.ppm);
    paint(g);
    this.tex.update();
  }
}
