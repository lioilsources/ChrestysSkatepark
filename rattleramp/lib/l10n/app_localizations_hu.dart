// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class L10nHu extends L10n {
  L10nHu([String locale = 'hu']) : super(locale);

  @override
  String get tapToRide => 'KOPPINTS ÉS GURULJ';

  @override
  String dailyTrick(String trick) {
    return 'A NAP TRÜKKJE: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STÍLUS: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'KÉPREGÉNY';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'MEHET!  $seconds';
  }

  @override
  String get wrongTrick => 'ROSSZ TRÜKK';

  @override
  String get tooEarly => 'TÚL KORÁN';

  @override
  String get waitForCircle => 'várd meg a kört';

  @override
  String get noTrick => 'NINCS TRÜKK';

  @override
  String get losingSpeed => 'veszítesz a sebességből';

  @override
  String get bailTiming => 'rossz időzítés';

  @override
  String get bailUnknown => 'ismeretlen trükk';

  @override
  String get bailTooLong => 'a trükk nem fért bele az airbe';

  @override
  String get outOfSpeed => 'ELFOGYOTT A SEBESSÉG';

  @override
  String get rideOver => 'VÉGE A MENETNEK';

  @override
  String get bestTrick => 'LEGJOBB TRÜKK';

  @override
  String get longestCombo => 'LEGHOSSZABB KOMBÓ';

  @override
  String get tricksLanded => 'TRÜKKÖK';

  @override
  String get avgTiming => 'ÁTLAGOS IDŐZÍTÉS';

  @override
  String get tapToContinue => 'KOPPINTS A FOLYTATÁSHOZ';

  @override
  String get tabGrabs => 'GRABEK';

  @override
  String get tabFlips => 'FLIPEK';

  @override
  String get tabSpins => 'SPINEK';

  @override
  String get tabCombos => 'KOMBÓK';

  @override
  String get trickBookHelp =>
      'A szélén körbe = spin (óramutató szerint FS, ellene BS) · középen át = grab · rombusz = flip. Fűzd össze a trükköket egy húzással – a következő ott kezdődik, ahol az előző véget ért. Engedd el, amikor a kör eléri a peremet.';

  @override
  String get spinNote => 'kezdd bárhol a szélén';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'HANGOLÁS (M0)';

  @override
  String get tuningWindow => 'Időzítési ablak szélessége';

  @override
  String get tuningLatency => 'Érintési késleltetés';

  @override
  String get tuningStartSpeed => 'Kezdősebesség';

  @override
  String get tuningCueLead => 'A kör előfutása';

  @override
  String get tuningDeltaHelp =>
      'Δ a menet jobb felső sarkában = az utolsó elengedés eltérése a peremtől (− korán, + későn).';

  @override
  String get avatarBeanie => 'Sapka';

  @override
  String get avatarDreads => 'Raszta';

  @override
  String get avatarHelmet => 'Sisak';

  @override
  String get avatarKid => 'Töpszli';
}
