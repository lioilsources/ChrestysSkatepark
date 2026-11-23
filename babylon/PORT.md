# RattleRamp → Babylon.js: mapa portu

Webový klient RattleRamp v TypeScriptu nad Babylon.js. Zdroj pravdy je Flutter projekt
`../rattleramp/` (pravidla v `lib/core/`). Plán: `DevConventions/Prompts/06-PLAN-babylon-web.md`.
Stav: **F2 (scéna a ovládání) hotovo**, další F3 (obsah). Hostování: GitHub Pages repa, hra pod `/play/`.

## Úrovně parity

- **P0** – diskrétní pravidla, shoda bit po bitu přes zlaté vektory z Dartu (`tool/dump_vectors.dart` → `test/golden/`).
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
| `core/ride_sim.dart` | 567 | `rules/ride-sim.ts` | P0 (události, časování, skóre) + P1 (dráha, póza) | **F1 hotovo** | 1:1 včetně póz triků a `replayJson()`; F0 `spike-ride.ts` smazán |
| `core/trick_defs.dart` | 237 | `rules/trick-defs.ts` | P0 | **F1 hotovo** | `npm run gen` kopíruje `assets/tricks.json` bajt po bajtu do `rules/generated/`; trik dne ověřen na 10 letech dní |
| `core/trick_parser.dart` | 110 | `rules/trick-parser.ts` | P0 | **F1 hotovo** | vektory: všechny tahy po mřížce do 5 kroků, všechny řetězitelné ≤3-tokenové sekvence, 3000 dlouhých náhodných |
| `core/scoring.dart` | 72 | `rules/scoring.ts` | P0 | **F1 hotovo** | 1500 rozpadů bodů; zaokrouhlení jako Dart `round()` (`dartRound`) |
| `core/avatar.dart` | 74 | `rules/avatar.ts` | P0 | **F2 hotovo** (data), výběr F3 | presety, outfity, decky; barvy ARGB int → CSS přes `argbToCss` v `ui/skater-paint.ts` |

### Zlaté vektory

`cd rattleramp && dart run tool/dump_vectors.dart` zapíše do `babylon/test/golden/`, `test/golden.test.ts` je přehraje:

| Soubor | Obsah | Shoda |
|---|---|---|
| `book.json` | všechny tokeny (cesty, looky), cesty komb, stupně 0–40 tahů, trik dne 2024–2033 | přesná |
| `parser.json` | ~46k vzorů → tokeny / kombo / chyba | přesná |
| `scoring.json` | 1500 vstupů (trik, timing, rychlost i mimo 0–1, streak, opakování, air, pro, daily) → rozpad | přesná |
| `rides.json` | 25 jízd skriptovaného hráče (seed, různé `startSpeed`, `windowScale`, `inputLatency`, `cueLead`, pro, daily): replay, všechny události, stav na začátku každého segmentu, statistiky; u 7 jízd póza každý 5. tik | diskrétní přesně, čísla ±1e-9 |

Pokrytí: všechny typy událostí, všechny důvody bailu i všechna hodnocení (test to hlídá).
CI (`web.yml`, job `golden`) vektory přegeneruje: `book`/`parser`/`scoring` musí sedět bajt po bajtu, `rides.json`
(sin/cos/exp se mezi platformami může lišit v posledním bitu) se ověří přehráním v TS s tolerancí.

### `lib/game/` (Flame, 807 ř.) → `src/game/`

| Dart | ř. | TS | Parita | Fáze | Poznámka |
|---|---|---|---|---|---|
| `game/rattle_game.dart` | 181 | `game/main.ts`, `game/scene.ts`, `rules/autopilot.ts` | P1/P2 | **F2 hotovo** | pevný krok `dt`, `rideNow` interpolace, `release()`, `WorldView.fit` → ortho kamera. Autopilot (`_botTick`) za `?demo`; attract obrazovka F3 |
| `game/ramp_component.dart` | 73 | `game/scene.ts` (`buildRamp`) | P2 | F0 hotovo bez loga | logo „U CHŘESTÝŠE“ na flatu: F3 (DynamicTexture nebo DOM) |
| `game/cue_component.dart` | 57 | `game/scene.ts` (cue ring) | P2 | F0 hotovo | |
| `game/skater_component.dart` | 343 | `ui/skater-paint.ts` (Canvas 2D) + `game/skater.ts` (DynamicTexture na rovině) | P2 | **F2 hotovo** bez spritů | IK rig, všech 6 grab stylů, flip roll/shove/tumble, bail, ocas maskota. Hlava = kruh (fallback z Dartu), sprity hlav a decků F3 |
| `game/style_paint.dart` | 118 | `game/styles.ts` | P2 | F3 | neon glow (GlowLayer nebo vlastní), komiks (ink outline), pixel (render do nižšího rozlišení, `hardwareScalingLevel`) |
| `game/avatar_sprites.dart` | 35 | `game/sprites.ts` | P2 | F3 | hlavy a decky jako textury na rovinách, načíst až po první obrazovce |

### `lib/ui/` (Flutter widgety, 1 701 ř.) → `src/ui/` (DOM + CSS)

| Dart | ř. | TS | Parita | Fáze | Poznámka |
|---|---|---|---|---|---|
| `ui/swipe_grid.dart` | 157 | `ui/swipe-pad.ts` | P0 (rozpoznání uzlů) / P2 | **F0 hotovo** | Pointer Events (dotyk i myš), hitRadius 0.36, doplnění přeskočeného uzlu, edge guard 18 px |
| `ui/ride_screen.dart` | 343 | `ui/hud.ts`, `rules/hints.ts`, `game/main.ts` (layout) | P2 | **F2 hotovo** | skóre, streak, rychlost, popup, Δ ms, hint strip, trik dne |
| `ui/pattern_painter.dart` | 73 | `ui/pattern.ts` (canvas 2D) | P2 | **F2 hotovo** | hinty; animace prstem (`progress`) připravená pro trick book (F3) |
| `ui/attract_screen.dart` | 186 | `ui/attract.ts` | P2 | F3 | úvod, Pro tlačítko, STYL přepínač |
| `ui/avatar_screen.dart` | 286 | `ui/avatar.ts` | P2 | F3 | výběr postavy, 5 s odpočet |
| `ui/trick_book_screen.dart` | 166 | `ui/trick-book.ts` | P2 | F3 | |
| `ui/stat_card.dart` | 90 | `ui/stat-card.ts` | P2 | **F2 hotovo** | konec jízdy, 2 s ignorace dotyků; klepnutí / mezerník = nová jízda (attract F3) |
| `ui/theme.dart` | 159 | `ui/palette.ts` | P2 | F0 neon, F3 komiks + pixel | barvy přepsány ručně (viz Odchylky) |
| `ui/tuning_panel.dart` | 85 | `ui/tuning.ts` za `?debug` | — | F3 | jen ladění, ukládání do localStorage |
| `ui/app.dart` | 156 | `ui/app.ts` | P2 | F3 | přepínání obrazovek, idle timeout |
| `main.dart` | 15 | `index.html` + `game/main.ts` | — | F0 | |

## Funkce

Seznam pro videa (plán kap. 5a): jedno video = jedna funkce a klient. Videa ani změny na olin.now
v F0 nevznikají. Stav **F** = Flutter (M0–M2), **W** = web. Složka videa: `Store/shorts/rattleramp/NN-<id>/`
(RattleRamp tam zatím nemá nic, číslování začíná od 01).

| id | Popis | Stav F | Stav W | Video |
|---|---|---|---|---|
| `ride` | Jízda v U-rampě coping → coping, rychlost roste s dobrými triky, bez triku klesá až do rolloutu | hotovo | F2 hotovo | `01-ride` |
| `timing` | Rytmický kruh se stahuje na coping, release se hodnotí PERFECT / GOOD / LATE / MISS, Δ ms | hotovo | F2 hotovo | `02-timing` |
| `swipe-grid` | Triky se kreslí tahem po mřížce 3×3 (dotyk i myš), přeskočený uzel se doplní | hotovo | F2 hotovo (+ klávesnice) | `03-swipe-grid` |
| `spins` | Otočky tahem po vnějším kruhu, směr = FS/BS, 180–1080 | hotovo | F2 hotovo | `04-spins` |
| `grabs` | Graby tahem přes střed, různé styly těla (tuck, tweak, stiff, split) | hotovo | F2 hotovo | `05-grabs` |
| `flips` | Flipy po diamantu, deska se točí (kickflip, heelflip, shove-it…) | hotovo | F2 hotovo | `06-flips` |
| `combos` | Řetězení spin + grab + flip v jednom tahu, delší trik = větší pump, nevejde-li se do airu → bail | hotovo | F2 hotovo | `07-combos` |
| `bail` | Pád při špatném načasování nebo neznámém tahu | hotovo | F2 hotovo | `08-bail` |
| `scoring` | Body = báze × timing × rychlost × combo × variety + air, streak, nejlepší trik | hotovo | F2 hotovo | `09-scoring` |
| `trick-of-day` | Trik dne za ×2, stejný pro všechny ten den | hotovo | F2 hotovo | `10-trick-of-day` |
| `pro-mode` | Pro režim: bez nápovědy, ×1,5 | hotovo | F2 za `?pro`, přepínač F3 | `11-pro-mode` |
| `hints` | Pruh nápověd s tahy triků dostupných při aktuální rychlosti | hotovo | F2 hotovo | `12-hints` |
| `trick-book` | Kniha triků se vzory tahů | hotovo | F3 | `13-trick-book` |
| `avatars` | 8 postav (maskot Chřestýš s chřestítkem), 6 outfitů, 6 desek, výběr do 5 s | hotovo | F3 | `14-avatars` |
| `art-styles` | Tři styly za běhu: neon, komiks, pixel | hotovo | F0 jen neon, F3 zbytek | `15-art-styles` |
| `attract` | Úvodní smyčka s demo jezdcem, klepnutí spustí jízdu | hotovo | F3 | `16-attract` |
| `stat-card` | Souhrn jízdy: skóre, landed, max streak, nejlepší trik, průměrné načasování | hotovo | F2 hotovo | `17-stat-card` |
| `web-play` | Hra v prohlížeči bez instalace, odkaz z olin.now (jen W) | — | F0 spike na `/play/` | `18-web-play` |

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
3. ~~`spike-ride.ts` místo plného `RideSim`~~ (F0). V F1 nahrazeno plným portem, soubor smazán.
   Od F1 hra pozná jen skutečné triky; neznámý tah = bail. Pruh nápověd je od F2.
4. **Shadery StandardMaterial jsou v hlavním bundlu** (import `Shaders/default.*`), ne líně: +31 kB gzip,
   ale o jeden round-trip dřív první snímek.
5. **Na výšku (telefon) je swipe pad pod rampou**, ne vpravo jako na tabletu. Flutter verze je jen na šířku;
   web se otevře i na telefonu, takže layout na výšku je navíc.
6. **Trik dne bere kalendářní den jako tři čísla** (`dailyToken(book, y, m, d)` + `dailyTokenFor(book, Date)`),
   ne `DateTime`. Výsledek je stejný: Dart si z `DateTime` stejně bere jen místní rok, měsíc a den.
7. **Parser vektory: tahy po mřížce do 5 kroků, ne do 6.** Do 6 kroků to bylo 4,4 MB; 5 kroků pokryje všechny
   chyby i krátké triky a delší vzory pokrývají řetězené sekvence a náhodné tahy (1,6 MB).
8. **Skejťák se kreslí Canvas 2D do DynamicTexture na rovině**, ne jako síť. Kód kreslení je přepis
   `paintSkater` 1:1 (stejné cesty, IK, styly), takže vzhled sedí a v F3 ho znovu použije výběr postavy.
   Neonová záře přes `shadowBlur` místo `MaskFilter.blur`.
9. **Ovládání klávesnicí** (jen web): fyzický blok Q W E / A S D / Z X C nebo numerická klávesnice skládá tah,
   mezerník / Enter ho pustí, Esc smaže. Pustit = okamžik releasu, jako zvednutí prstu.
10. **`?pro` a `?demo` už v F2.** `?pro` skryje nápovědy a násobí ×1,5 (přepínač na úvodní obrazovce v F3).
   `?demo` pustí autopilota z attract módu: jízdy běží dokola, vstup se ignoruje. Slouží i pro záznam videí.
11. **`rules/avatar.ts` už v F2** (plán F3): rig potřebuje barvy outfitu. Výběr postavy zůstává v F3.
