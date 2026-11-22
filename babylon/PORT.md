# RattleRamp → Babylon.js: mapa portu

Webový klient RattleRamp v TypeScriptu nad Babylon.js. Zdroj pravdy je Flutter projekt
`../rattleramp/` (pravidla v `lib/core/`). Plán: `DevConventions/Prompts/06-PLAN-babylon-web.md`.
Stav: **F0 (audit + spike)**. Hostování: GitHub Pages repa, hra pod `/play/`.

## Úrovně parity

- **P0** – diskrétní pravidla, shoda bit po bitu přes zlaté vektory z Dartu (`tool/dump_vectors.dart` → `test/golden/`, F1).
- **P1** – spojitá fyzika: ±5 % ve scénářích (časy hran, délky airu, rychlost po N segmentech).
- **P2** – vzhled: stejný výchozí pohled (ortografický bok rampy), barvy, rozložení. Ne pixel po pixelu.

## Vrstvy

| Složka | Obsah | Hranice (ESLint) |
|---|---|---|
| `src/rules/` | port `lib/core/`, čisté TS | bez `@babylonjs/*`, bez DOM globálů, bez `game/` a `ui/` |
| `src/game/` | Babylon scéna, herní smyčka, napojení vstupu | smí vše |
| `src/ui/` | DOM overlay: swipe pad, HUD, obrazovky | bez Babylonu, bez `game/` |
| `scripts/` | generátory přes `tsx` (čte Dart zdroje) | — |

## Mapa Dart → TS po souborech

Řádky = `wc -l` k 22. 11. 2026.

### `lib/core/` (1 302 ř., čistý Dart) → `src/rules/`

| Dart | ř. | TS | Parita | Fáze | Poznámka |
|---|---|---|---|---|---|
| `core/grid.dart` | 68 | `rules/grid.ts` | P0 | **F0 hotovo** | 1:1, testy `test/grid.test.ts` |
| `core/ramp.dart` | 61 | `rules/ramp.ts` | P1 | **F0 hotovo** | 1:1, testy `test/ramp.test.ts` |
| `core/ride_config.dart` | 113 | `rules/ride-config.ts` + `rules/generated/ride-config.ts` | P0 | **F0 hotovo** | výchozí hodnoty generuje `npm run gen` z Dartu, `test/config-sync.test.ts` hlídá rozjezd |
| `core/ride_sim.dart` | 567 | `rules/ride-sim.ts` | P0 (události, časování, skóre) + P1 (dráha, póza) | F1 | v F0 jen `rules/spike-ride.ts`: segmenty, tabulka vzdáleností, air, posouzení releasu, pózy bez triků. Nahradí ho plný port |
| `core/trick_defs.dart` | 237 | `rules/trick-defs.ts` | P0 | F1 | `assets/tricks.json` se kopíruje beze změny (generátor/`public/`), daily trick musí dát stejný den → stejný trik |
| `core/trick_parser.dart` | 110 | `rules/trick-parser.ts` | P0 | F1 | zlaté vektory: všechny řetězitelné ≤3-tokenové sekvence (>10k vzorů, jako `test/trick_parser_test.dart`) |
| `core/scoring.dart` | 72 | `rules/scoring.ts` | P0 | F1 | vektory: rozpad bodů pro sadu (trik, timing, rychlost, combo, variety, pro, daily) |
| `core/avatar.dart` | 74 | `rules/avatar.ts` | P0 | F3 | presety, outfity, decky; barvy ARGB int → CSS přes helper v `ui/` |

Zlaté vektory (F1): `tool/dump_vectors.dart` spustí parser, scoring a `RideSim` nad pevnými vstupy
(replay JSON, `RideSim.replayJson()`) a vypíše události + stav po každém segmentu. Vitest je přehraje.

### `lib/game/` (Flame, 807 ř.) → `src/game/`

| Dart | ř. | TS | Parita | Fáze | Poznámka |
|---|---|---|---|---|---|
| `game/rattle_game.dart` | 181 | `game/main.ts`, `game/scene.ts` | P1/P2 | F0 kostra, F2 | pevný krok `dt`, `rideNow` interpolace, `release()`, `WorldView.fit` → ortho kamera. Autopilot (attract) F3 |
| `game/ramp_component.dart` | 73 | `game/scene.ts` (`buildRamp`) | P2 | F0 hotovo bez loga | logo „U CHŘESTÝŠE“ na flatu: F3 (DynamicTexture nebo DOM) |
| `game/cue_component.dart` | 57 | `game/scene.ts` (cue ring) | P2 | F0 hotovo | |
| `game/skater_component.dart` | 343 | `game/skater.ts` | P2 | F2 | IK rig (stehno/holeň/paže), grab styly, flip roll/shove/tumble. V F0 jen panáček (deska + trup + hlava) |
| `game/style_paint.dart` | 118 | `game/styles.ts` | P2 | F3 | neon glow (GlowLayer nebo vlastní), komiks (ink outline), pixel (render do nižšího rozlišení, `hardwareScalingLevel`) |
| `game/avatar_sprites.dart` | 35 | `game/sprites.ts` | P2 | F3 | hlavy a decky jako textury na rovinách, načíst až po první obrazovce |

### `lib/ui/` (Flutter widgety, 1 701 ř.) → `src/ui/` (DOM + CSS)

| Dart | ř. | TS | Parita | Fáze | Poznámka |
|---|---|---|---|---|---|
| `ui/swipe_grid.dart` | 157 | `ui/swipe-pad.ts` | P0 (rozpoznání uzlů) / P2 | **F0 hotovo** | Pointer Events (dotyk i myš), hitRadius 0.36, doplnění přeskočeného uzlu, edge guard 18 px |
| `ui/ride_screen.dart` | 343 | `ui/hud.ts`, `game/main.ts` (layout) | P2 | F0 kostra, F2 | skóre, streak, rychlost, popup, Δ ms, hint strip, trik dne |
| `ui/pattern_painter.dart` | 73 | `ui/pattern.ts` (canvas 2D) | P2 | F2 | hinty a trick book |
| `ui/attract_screen.dart` | 186 | `ui/attract.ts` | P2 | F3 | úvod, Pro tlačítko, STYL přepínač |
| `ui/avatar_screen.dart` | 286 | `ui/avatar.ts` | P2 | F3 | výběr postavy, 5 s odpočet |
| `ui/trick_book_screen.dart` | 166 | `ui/trick-book.ts` | P2 | F3 | |
| `ui/stat_card.dart` | 90 | `ui/stat-card.ts` | P2 | F2 | konec jízdy, 2 s ignorace dotyků |
| `ui/theme.dart` | 159 | `ui/palette.ts` | P2 | F0 neon, F3 komiks + pixel | barvy přepsány ručně (viz Odchylky) |
| `ui/tuning_panel.dart` | 85 | `ui/tuning.ts` za `?debug` | — | F3 | jen ladění, ukládání do localStorage |
| `ui/app.dart` | 156 | `ui/app.ts` | P2 | F3 | přepínání obrazovek, idle timeout |
| `main.dart` | 15 | `index.html` + `game/main.ts` | — | F0 | |

## Co se na webu vypouští

- **Kiosk (M4):** lock-task, Guided Access, PIN admin. Web je odkaz, ne kiosk.
- **Ikona kreslená v testu, `flutter_launcher_icons`, `tool/spritegen.py`:** generování assetů se neportuje (SPARK se nepoužívá). PWA ikony v F4 z hotového `assets/icon/icon.png`.
- **Testy obrazu** (`snapshot_test`, `gallery_test`, `avatar_sheet_test`, `icon_test`): nahrazuje je ruční kontrola + screenshoty, žádná pixel parita.
- **IAP, reklamy, žebříčky obchodů:** RattleRamp je nemá; web je celá hra zdarma.
- Budoucí M3 (replaye, iniciály, žebříček v baru) a M5: řeší se, až budou ve Flutteru.

## Assety

Celkem `rattleramp/assets/` 2,1 MB.

| Soubor | Velikost | Na webu | Kdy |
|---|---|---|---|
| `tricks.json` | 4,3 kB | ano, beze změny | F1 (první obrazovka) |
| `sprites/heads/*.png` (8 ks) | 484 kB (48–72 kB/ks) | ano | F3, dotáhnout po prvním snímku |
| `sprites/decks/*.png` (6 ks) | 450 kB (35–104 kB/ks) | ano | F3, dotáhnout po prvním snímku |
| `icon/icon.png` | 546 kB | zmenšené PWA ikony | F4 |
| `icon/icon_background.png`, `icon_foreground.png` | 502 + 128 kB | ne (Android adaptive) | — |
| Zvuky | žádné | — | hra zatím nemá audio; chybějící asset se nehlásí jako chyba |
| Fonty | systémové (Flutter tahá Roboto z Google Fonts) | systémový font | — |

Sprity (~0,9 MB) se mají převést na WebP/AVIF až po rozhodnutí Olina (konverze ≠ generování, ale mění soubory).

## Měření F0 (lokálně, 22. 11. 2026)

Stroj: MacBook (Apple Silicon), Chromium 1254 přes Playwright, okno 1180×820 (tablet na šířku),
servírováno `vite preview` (gzip) pro obě verze. Mediány ze 3 běhů. „Škrcení“ = 4 Mbit/s, RTT 100 ms, CPU ×4
(hrubá náhrada slabšího telefonu na mobilních datech). Na referenčním telefonu měří Olin.

| | Flutter web (`flutter build web --release`, 3.47.9, CanvasKit) | Babylon spike |
|---|---|---|
| Build na disku | 41 MB (z toho 36 MB `canvaskit/` ve všech variantách) | 1,5 MB `dist/` |
| Přeneseno do prvního snímku | 3,1 MB (canvaskit.wasm 1,5 MB, main.dart.js 0,67 MB, sprity 0,9 MB, Roboto) | 0,27 MB (JS 1,19 MB raw / 279 kB gzip) |
| První snímek, rychlá síť | ~0,87 s (`flutter-first-frame`) | ~0,12 s (první snímek s hotovými shadery) |
| První snímek, škrcení | ~9,2 s | ~1,1 s |
| FPS (desktop, `?debug`) | — | 120 (vsync) |

Flutter se měřil na dočasné kopii projektu (`flutter create --platforms=web` mimo repo), nic z buildu
není v repu. CI repa pinuje Flutter 3.50.x, lokálně byl 3.47.9; velikost se mezi verzemi mění málo.

## Odchylky

1. **Barvy neon stylu jsou v `ui/palette.ts` přepsané ručně** z `ui/theme.dart`. Plán chce čísla ze stejných
   zdrojů přes generátor. Pro F0 stačí jeden styl; v F3 přibude generátor `scripts/gen-palette.ts`,
   který čte `styleSpecs` z `theme.dart` (stejně jako `gen-config.ts` čte `ride_config.dart`).
2. **Texty nejsou z ARB.** Flutter verze ARB nemá, texty jsou česky natvrdo ve widgetech
   (`ride_screen.dart` aj.). Web je zatím přebírá stejně; až Flutter přejde na ARB, web je převezme generátorem.
3. **`spike-ride.ts` místo plného `RideSim`** v F0: bez parseru a skóre je každý tah ≥3 uzly „trik“.
   Fyzika segmentů, časová okna a pózy jsou ale přepsané 1:1, aby šel porovnat feel. V F1 soubor zmizí.
4. **Shadery StandardMaterial jsou v hlavním bundlu** (import `Shaders/default.*`), ne líně: +31 kB gzip,
   ale o jeden round-trip dřív první snímek.
5. **Na výšku (telefon) je swipe pad pod rampou**, ne vpravo jako na tabletu. Flutter verze je jen na šířku;
   web se otevře i na telefonu, takže layout na výšku je navíc.
