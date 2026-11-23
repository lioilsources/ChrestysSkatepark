# RattleRamp v prohlížeči (Babylon.js)

Webová verze hry: <https://lioilsources.github.io/ChrestysSkatepark/play/>.
Je to port Flutter aplikace (`rattleramp/`) do TypeScriptu nad Babylon.js 9 (WebGL2). Kód je v `babylon/`,
mapa portu soubor po souboru, paritní úrovně a odchylky jsou v [`babylon/PORT.md`](https://github.com/lioilsources/ChrestysSkatepark/blob/main/babylon/PORT.md).

## Spuštění

```bash
cd babylon
npm ci
npm run dev      # http://localhost:5173 (sprity se zkopírují samy)
npm run gate     # lint + testy + build, totéž běží v CI
```

Deep linky: `?ride` rovnou jízda, `?pro` Pro jízda, `?demo` autopilot na obrazovce jízdy (videa), `?debug` FPS.
Ovládání: dotyk nebo myš na mřížce 3×3, nebo klávesy Q W E / A S D / Z X C (numerická klávesnice), mezerník pustí tah.

## Vrstvy

| Složka | Obsah |
|---|---|
| `src/rules/` | čistá pravidla (parser triků, scoring, simulace jízdy, autopilot), bez Babylonu a DOM, hlídá ESLint |
| `src/game/` | Babylon scéna (ortografická kamera, rampa, sprity na rovinách), herní smyčka, přepínání obrazovek |
| `src/ui/` | DOM a Canvas 2D: HUD, mřížka, obrazovky, kreslení skejťáka a stylů |

## Jedna pravda: Flutter

Nic se nepíše podruhé ručně:

- `npm run gen` čte `rattleramp/lib/core/ride_config.dart` (čísla jízdy), `rattleramp/lib/ui/theme.dart` (styly)
  a kopíruje `rattleramp/assets/tricks.json`. Test `config-sync` spadne, když se vygenerované soubory rozjedou.
- `npm run assets` (před `dev` a `build`) kopíruje sprity z `rattleramp/assets/sprites/` do `public/` (nejsou v gitu).
- Zlaté vektory: `cd rattleramp && dart run tool/dump_vectors.dart` zapíše výstupy Dart pravidel do
  `babylon/test/golden/` a Vitest je přehraje (parser, scoring, trik dne, 25 jízd včetně póz).
  CI job `golden` je přegeneruje a porovná. Kdo změní pravidla v `lib/core/`, spustí nástroj a commitne vektory.

## Nasazení

Workflow `.github/workflows/web.yml`: při push do `main` postaví `babylon/`, zkopíruje `docs/` do kořene a hru
pod `/play/` a nasadí na GitHub Pages (zdroj Pages = GitHub Actions). Na olin.now vede na hru pole `play:`
v `apps/rattleramp/meta.md` (tlačítko „Hrát v prohlížeči“).
