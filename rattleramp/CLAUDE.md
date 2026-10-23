# CLAUDE.md — RattleRamp

Tablet kiosk skate game for bar U Chřestýše. Plan: `../Prompts/00-RATTLERAMP_PLAN.md`.
Implemented: **M0** (feel prototype) + **M1** (trick grammar, trick book, hint strip, scoring).
M2–M5 not started — the plan gates everything on M0 feeling right on the real tablet.

## Decisions from Ol1n (open questions in the plan)

- Visual style: all three (neon / comic / pixel), switchable at runtime.
- Platforms: both iPad and Android tablets. Kiosk (M4) must cover both: Android lock-task/screen pinning,
  iPad Guided Access (or MDM single-app mode).

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
- Skater = separate board/body layers. Spin = horizontal squash of the rig; flip = board roll/shove/tumble from
  the flip's `look` in tricks.json; grab = hand + spot + body style (`GrabStyle`) + tilt from the grab's `look`.
  `SNAP_DIR=/tmp/x flutter test test/gallery_test.dart` renders every grab and flip upright for a visual check.
- Art styles (`ArtStyle` in `lib/ui/theme.dart`): neon, comic, pixel. `Palette.*` are getters on the active
  style — never cache a palette colour in a `static final`/`const`. Game shapes go through `drawStyled`
  (`lib/game/style_paint.dart`) which adds comic ink outlines or neon glow; pixel renders the whole game layer at
  1/n resolution. Switch: STYL button on attract, or the tuning panel. Screen keys carry the style, so a switch
  remounts the screen.
- App icon (rattlesnake on a skateboard) is drawn in code: `ICON_OUT=assets/icon flutter test
  test/icon_test.dart && dart run flutter_launcher_icons`. The tool rewrites
  `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` in the iOS pbxproj — revert that hunk.
  Linux has no generator: `sips -Z 256 assets/icon/icon.png --out linux/app_icon.png` (release-linux.yml packs it
  into the AppImage).
- Tuning panel: 3 s long-press top-left corner on attract. In-memory only, no PIN yet (M4).
- `dart format -l 120`.
