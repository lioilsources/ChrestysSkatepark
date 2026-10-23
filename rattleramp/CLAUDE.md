# CLAUDE.md — RattleRamp

Tablet kiosk skate game for bar U Chřestýše. Plan: `../Prompts/00-RATTLERAMP_PLAN.md`.
Implemented: **M0** (feel prototype) + **M1** (trick grammar, trick book, hint strip, scoring).
M2–M5 not started — the plan gates everything on M0 feeling right on the real tablet.

## Layout

```
lib/core/   pure Dart, no Flutter/Flame imports — deterministic, unit-tested
  grid.dart          3×3 geometry, move classes
  trick_defs.dart    TrickBook loaded from assets/tricks.json, daily trick
  trick_parser.dart  node path → tokens → ParsedTrick
  scoring.dart       body = Σbase × timing × speed × combo × variety (+air) (×1.5 Pro, ×2 daily)
  ramp.dart          U-ramp profile, path parameter s
  ride_sim.dart      fixed-step ride state machine, judgement, pose, replay JSON
  ride_config.dart   EVERY feel constant lives here
lib/game/   Flame rendering only (RattleGame steps RideSim, draws ramp/cue/skater)
lib/ui/     Flutter screens: attract, ride (HUD, hints, SwipeGrid), trick book, stat card, tuning panel
assets/tricks.json   trick definitions
```

## Commands

```bash
flutter test                                        # parser collision test, sim, scoring, UI smoke
SNAP_DIR=/tmp/x flutter test test/snapshot_test.dart  # render ride frames to PNG
flutter run -d macos | android | ios
```

## Trick grammar (design decision)

Each of the 20 grid edges has exactly one move class, so tokenisation is unique by construction:
- **ring** (orthogonal step between outer nodes) → spin; clockwise = FS. Starts anywhere on the ring.
  4k−1 … 4k+2 steps = k half-turns (sloppy-finger tolerance), capped at 1080.
- **center** (any step touching node 4) → grab, always `a→4→b`; grabs can chain.
- **diamond** (diagonal between 1/3/5/7) → flip, whole run must match one flip exactly.
Combos chain: each token starts where the previous ended. Plan said flips "zig-zag through the centre";
moved to the diamond so grabs and flips never share edges. `test/trick_parser_test.dart` enumerates all
chainable ≤3-token sequences (>10k patterns) and asserts unique parse; it also checks combos are drawable.

## Ride timing

A segment = roll coping→coping (`segStart → tEdge`) + air (`tEdge → tLand`); both known when the segment
starts. A release is judged only by `t − tEdge`: perfect/good (±), late (+ only), else miss. Releases earlier
than `cueLead` are ignored ("MOC BRZY"), < 3-node paths are ignored (palm/tap). Miss or unknown pattern →
bail; trick longer than the remaining air → bail on landing; no trick → speed loss, speed < 0 → rollout end.
Windows shrink with speed. `inputLatency` is subtracted from release time (tune on the tablet).

## Conventions

- Gameplay logic only in `lib/core`; Flame/Flutter read `RideSim` state and never mutate it except via `addInput`.
- Same config + same inputs ⇒ same ride. Don't add RNG/wall-clock to the sim (replays in M3 rely on it).
- Skater = separate board/body layers (spin = horizontal squash of the rig, flip = board roll, grab = arm pose).
- Tuning panel: 3 s long-press top-left corner on attract. In-memory only, no PIN yet (M4).
- `dart format -l 120`.
