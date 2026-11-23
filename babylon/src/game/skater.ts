// Skater in the Babylon scene: a sprite plane at the board contact point, rotated to
// the pose angle, redrawn every frame by ui/skater-paint.ts (Canvas 2D port of
// skater_component.dart).
import type { Scene } from '@babylonjs/core/scene';

import type { Avatar } from '../rules/avatar';
import type { SkaterPose } from '../rules/ride-sim';
import { paintSkater } from '../ui/skater-paint';
import type { AvatarSprites } from '../ui/sprites';
import { SpritePlane } from './sprite-plane';

/** Skater-local box the rig can reach (bail, spread grab, split, head sprite). */
const BOX = { left: -1.6, right: 1.6, bottom: -0.9, top: 2.5 };

export class SkaterSprite {
  private readonly plane: SpritePlane;

  constructor(scene: Scene, private readonly avatar: Avatar, private sprites: AvatarSprites) {
    this.plane = new SpritePlane(scene, 'skater', BOX, 512, -0.05);
  }

  setSprites(s: AvatarSprites): void { this.sprites = s; }

  sync(p: SkaterPose): void {
    this.plane.root.position.set(p.x, p.y, -0.05);
    this.plane.root.rotation.z = p.angle;
    this.plane.draw((g) => paintSkater(g, p, this.avatar, this.sprites));
  }
}
