# RATTLERAMP_PLAN.md — U-rampa pro bar U Chřestýše

Handoff pro Opus (Claude Code Director). Pracovní název **RattleRamp** (chřestýš = rattlesnake; klidně přejmenovat). Tablet hra pro hosty baru/občerstvení U Chřestýše u skate parku — zákazník si zahraje, zatímco čeká na objednávku.

## 1. Cíl a mantinely

- **Co to je:** 2D side-view U-rampa. Skejťák jezdí sám (auto-pumping), hráč na každé hraně rampy swipne trik jako 3×3 pattern (styl Android unlock). Rozhoduje **timing swipe vůči hraně (coping)**. Trefí → trik se odehraje, body, jede dál. Netrefí / špatný pattern / nestihne → bail, konec jízdy.
- **Kontext použití:** tablet připevněný u baru, landscape, kiosk. Host přijde, tapne, hraje 30–120 s, odejde. **Nic nesmí vyžadovat vysvětlování obsluhou.**
- **Tvrdé požadavky:** rychlé (start hry < 2 s od tapu), 60 fps na levném Android tabletu, **100 % offline**, landscape only, žádné účty, žádná reklama, žádné nastavení dostupné hostům.
- **Stack:** Flutter + Flame (jako Kiran/ImmunoRun), čistý Dart herní core bez Flame závislosti (testovatelný, deterministický), lokální DB (drift/SQLite nebo Hive) pro leaderboard + replaye, trik definice v JSON/YAML assetu.

## 2. Herní smyčka (core)

```
attract loop (idle) → TAP → výběr avatara (≤ 5 s) → RIDE → bail → score + zápis iniciál → attract loop
```

**Ride:**
1. Skejťák sjede z platformy, přejede flat, vyjede protější stěnu.
2. Blížící se hrana = **timing window** (vizuálně zmenšující se prstenec / rostoucí lišta — rhythm-game cue, čitelné i v hlučném baru bez zvuku).
3. Hráč swipne pattern. Hodnotí se **moment uvolnění prstu** vůči momentu, kdy skejťák opustí hranu: `perfect` / `good` / `late` / `miss`.
4. Air: trik se přehraje. Délka airu = f(rychlost). **Pattern delší, než kolik air umožní → skejťák dopadne uprostřed triku → bail.** (Tím se přirozeně svazuje obtížnost triku s rychlostí jízdy.)
5. Landing: přičtou se body, upraví rychlost, skejťák sjíždí na druhou stranu. Opakovat se střídáním stěn.
6. Žádný swipe v okně = „no trick air“ → ztráta rychlosti (po 2–3 prázdných airech už nedoletí na coping → ride končí přirozeně, ne bailem).

**Rychlost:**
- Startovní rychlost = střední. Povedený trik + rychlost (perfect timing víc). Late timing − rychlost. Delší/těžší triky dávají víc rychlosti.
- Rychlost postupně roste → kratší timing okna → přirozená obtížnostní křivka. Horní limit rychlosti (cap) ať jízda nekončí jen únavou prstu.
- Rychlost určuje výšku airu → delší air → místo na dlouhé patterny (720, kombinace).

## 3. Swipe systém (3×3)

- Mřížka 3×3 viditelná jako poloprůhledný overlay vpravo dole (dosah palce). Velikost min. 40 % výšky obrazovky. **Rozhodnout v M0:** fixní mřížka vs. „relativní“ (vznikne tam, kde se prst dotkne) — relativní je rychlejší, fixní je čitelnější pro úplné nováčky. Default: fixní, relativní jako volba v adminu.
- Pattern = posloupnost uzlů, pohyb po 8 směrech na sousední uzel. **Uzly se smějí opakovat** (nutné pro 720 = dva okruhy). Tím se liší od Android unlocku.
- Vstup se rozpoznává živě (dráha svítí), konec patternu = zvednutí prstu. Debounce na nechtěné dotyky okrajem dlaně.
- Odchylka: vyhodnocuje se sekvence uzlů, ne přesná křivka — tolerantní k ledabylému prstu.

### 3.1 Gramatika triků (klíčová designová myšlenka)

Místo pouhého lookupu „pattern → trik“ je pattern **složený z tokenů**, parser je rozseká a složí název + body. Dává to kombinatoricky „maximální seznam triků“ s malým počtem definic.

- **Spin:** uzavřený okruh po 8 vnějších uzlech. Po směru hodin = frontside, proti = backside. Půlokruh = 180, celý = 360, 1,5 = 540, 2 = 720, 2,5 = 900, 3 = 1080.
- **Grab:** krátký „hák“ 2–3 uzly (Indy, Melon, Mute, Stalefish, Method, Nosegrab, Tailgrab, Japan, Rocket Air, Crail, Seatbelt, Benihana, Christ Air, Airwalk…). Každý grab má svůj unikátní tvar.
- **Flip:** cik-cak přes střed (Kickflip, Heelflip, Varial, 360 Flip, Hardflip, Inward Heel, Laser, Pop Shove-it, Impossible…).
- **Invert/handplant** (M2+): pattern začínající na horním řádku a vracející se tam.
- **Kombinace** = tokeny za sebou v jednom airu: `grab + spin` → „Indy 540“, `flip + spin` → „360 Flip to Fakie“, `grab + spin + flip` → vymyšlený název + bonus. Speciální pojmenované kombinace (McTwist, Caballerial, 540 Japan, Rodeo…) mají vlastní položku v trick booku a bonusové body.
- Validace v parseru: žádné dva tokeny nesmějí mít sdílený prefix tak, aby byl pattern nejednoznačný (unit test generuje všechny kombinace a kontroluje kolize).

### 3.2 Trick book

- Obrazovka s úplným seznamem triků, kategorie, pattern animovaný prstem, body. Dostupná z attract screenu.
- Během jízdy **hint strip** (Beginner mode): dole 3 náhodné patterny s názvy, hráč může opisovat. **Pro mode:** bez hintů, ×1,5 skóre. Volba na startu (default Beginner).
- Trik má „stupeň“ (1–5): délka patternu ≈ potřebná rychlost.

## 4. Skóre

```
body = Σ(token.base) × timing_mult × speed_mult × combo_mult × variety_mult + air_height_bonus
```
- timing: perfect 1,5 / good 1,0 / late 0,6.
- speed_mult: lineárně s rychlostí (1,0–2,0).
- combo_mult: +0,1 za každý povedený trik v řadě (reset na bail — tj. jen roste).
- variety_mult: opakování téhož triku v jízdě dává 50 %, pak 25 % (styl Tony Hawk — nutí prozkoumávat trick book).
- air_height_bonus: za vysoký air.
- Na konci jízdy: celkem, nejlepší trik, nejdelší combo, průměrný timing — krátký „stat card“ (2 s, pak vstup iniciál).

## 5. Postavy / avatar

- 6–8 presetů (kluk/holka, různé styly, jeden **chřestýš maskot** baru jako unlock/easter egg).
- Rychlá tvorba (≤ 5 s): 3 slidery/klikačky — barva pleti, vlasy, outfit barva, grafika desky. Žádné texty.
- **Technicky:** skejťák a deska jako **oddělené vrstvy** (Flame SpriteComponent): rotace spinu = rotace celé skupiny, grab = jedna z N póz těla, flip = rotace/flip sprite desky. Tím je N póz × M spinů × K flipů složitelných bez ručních animací pro každou kombinaci. Barvy avataru přes palette-swap shader nebo vrstvené sprity.
- Assety: vlastní ComfyUI pipeline (jako Kiran) — side-view sprite sheety póz; stylově neon/minimal nebo komiks podle branding baru.

## 6. Replay a archiv

- Hra je deterministická (seed + záznam vstupů s časovými razítky) → replay = pár set bajtů. Ukládá se každá jízda nad prahem (např. top 50 + poslední 20).
- Přehrání ze score screenu („Pusť si to znovu“) a z leaderboardu.
- **Attract loop** přehrává náhodně top replaye s overlayem „TAPNI A JEĎ“ + jméno/skóre — zároveň reklama hry sama na sebe.
- Později: export replaye jako video/GIF přes share sheet (telefon hosta, QR mimo scope).

## 7. Leaderboard

- Lokální. Záložky **Dnes / Tento týden / Všech dob**. Vstup iniciál arcade style (3 znaky, kolečko) — žádná klávesnice.
- **Bar mechanika (doporučeno):** denní vítěz dostane odměnu (panák/pivo/sleva). Na attract screenu „Kdo dnes vede: XYZ — 12 340“. Admin na konci dne vidí vítěze; odměnu nastavuje v adminu (text), hra ji jen zobrazuje. Tohle je to, co lidi vrátí k tabletu.
- „Trik dne“ — náhodně vybraný trik ×2 body, mění se o půlnoci.
- Hot-seat VS mód: 2 hráči střídavě, nejlepší ze 2 jízd. Kamarádi u stolu.

## 8. Kiosk, admin, provoz

- **Kiosk:** Android screen pinning / Fully Kiosk (nebo iPad Guided Access). Obrazovka stále zapnutá, noční ztlumení jasu podle otevíračky. Žádné systémové gesta, žádný back.
- **Idle reset:** 20 s bez dotyku v menu → attract. Rozehraná jízda bez dotyku → skejťák dojede a ride končí.
- **Admin:** skryté gesto (3 s long press v rohu + PIN). Reset leaderboardu, obtížnost (startovní rychlost, šířka timing okna, Beginner/Pro default), text odměny, fixní/relativní mřížka, zvuk on/off, export CSV (počet her/den, průměrná délka, nejhranější triky) přes share sheet.
- **Zvuk:** bar je hlučný → vše musí fungovat beze zvuku; zvuk jako bonus (kolečka, grind, náraz, crowd), globální mute v adminu.
- **Branding:** logo U Chřestýše na rampě, rampa tvarovaná podle skutečného skate parku vedle (pokud lze), chřestýš maskot.
- **Hygiena/hardware:** poznámka pro bar — tvrzené sklo, držák, kabel; app ignoruje touch na okrajích (ochrana před rámem).

## 9. Nápady navíc (backlog, neblokují MVP)

- Lip tricky (rock to fakie, axle stall, blunt, disaster): pattern začínající v okamžiku dojezdu na coping místo odrazu → druhý typ timing okna.
- Chřestýš přebíhající rampu — easter egg, nutno ho přeskočit (speciální pattern) → bonus.
- Místní „Hall of Fame“ tisk (bar si vytiskne měsíční top 10).
- Sync více tabletů přes lokální Wi-Fi (bez internetu) — později, až bude víc než jeden tablet.
- Sezónní skiny rampy (Vánoce, léto).
- Achievementy (první 900, 10× perfect v řadě) — zobrazit jen jako badge u iniciál.
- Mobilní verze pro hosty domů (store) — stejný core, jiná shell; QR na tabletu. Vyžaduje rozhodnutí o monetizaci (mimo tento plán).

## 10. Milníky

- **M0 — Feel prototype (nejdůležitější):** rampa, fyzika sjezdu/výjezdu, jeden trik (360), timing okno, bail. Ladit timing tolerance proti touch latenci reálného tabletu. **Hra stojí a padá na tomhle milníku — dokud to „nesedí“, nepokračovat.**
- **M1 — Gramatika triků:** parser tokenů, 10 grabů, 6 spinů, 8 flipů, kombinace, kolizní test, trick book, hint strip, skóre.
- **M2 — Avatar:** vrstvený skater, presety, rychlá tvorba, ComfyUI sprite pipeline.
- **M3 — Leaderboard + replay:** DB, deterministický replay, attract loop, iniciály, Dnes/Týden/Vždy, trik dne, VS mód.
- **M4 — Kiosk + admin:** pinning, idle reset, admin PIN screen, export CSV, odměna dne.
- **M5 — Polish:** zvuk, particle efekty, branding, onboarding animace (15 s tutorial v attract loopu), test na cílovém tabletu v baru na týden.

## 11. Otevřené otázky pro Ol1na

1. Konkrétní tablet (Android/iPad, model) — ovlivní kiosk řešení a cílový fps.
2. Vizuální styl: neon minimal (jako Puff), komiks, nebo pixel art? Ovlivní ComfyUI pipeline.
3. Má jízda tvrdě končit prvním bailem (arcade), nebo dát 1 „save“ (např. ruka na coping) za jízdu?
4. Odměna dne — chce to bar reálně provozovat? Pokud ano, M4 povýšit.
5. Fixní vs. relativní mřížka — rozhodnout po M0 testu s 5 lidmi z baru.
6. Jména triků česky (Indy = Indy, ale „360 flip“ vs. „tre flip“) — držet anglické názvy, popisky česky?
