// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class L10nSl extends L10n {
  L10nSl([String locale = 'sl']) : super(locale);

  @override
  String get tapToRide => 'TAPNI IN VOZI';

  @override
  String dailyTrick(String trick) {
    return 'TRIK DNEVA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'SLOG: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'STRIP';

  @override
  String get stylePixel => 'PIKSEL';

  @override
  String goCountdown(int seconds) {
    return 'VOZI!  $seconds';
  }

  @override
  String get wrongTrick => 'NAPAČEN TRIK';

  @override
  String get tooEarly => 'PREZGODAJ';

  @override
  String get waitForCircle => 'počakaj na krog';

  @override
  String get noTrick => 'BREZ TRIKA';

  @override
  String get losingSpeed => 'izgubljaš hitrost';

  @override
  String get bailTiming => 'slab občutek za čas';

  @override
  String get bailUnknown => 'neznan trik';

  @override
  String get bailTooLong => 'trik ni šel v skok';

  @override
  String get outOfSpeed => 'ZMANJKALO HITROSTI';

  @override
  String get rideOver => 'KONEC VOŽNJE';

  @override
  String get bestTrick => 'NAJBOLJŠI TRIK';

  @override
  String get longestCombo => 'NAJDALJŠI KOMBO';

  @override
  String get tricksLanded => 'TRIKOV';

  @override
  String get avgTiming => 'POVPREČEN TIMING';

  @override
  String get tapToContinue => 'TAPNI ZA NADALJEVANJE';

  @override
  String get tabGrabs => 'GRABI';

  @override
  String get tabFlips => 'FLIPI';

  @override
  String get tabSpins => 'SPINI';

  @override
  String get tabCombos => 'KOMBI';

  @override
  String get trickBookHelp =>
      'Po robu = spin (v smeri urinega kazalca FS, v nasprotni BS) · čez sredino = grab · romb = flip. Poveži trike v eni potezi – naslednji se začne tam, kjer se je prejšnji končal. Spusti prst, ko krog doseže rob.';

  @override
  String get spinNote => 'začni kjer koli na robu';

  @override
  String pointsShort(int points) {
    return '$points t';
  }

  @override
  String get tuningTitle => 'NASTAVITVE (M0)';

  @override
  String get tuningWindow => 'Širina časovnega okna';

  @override
  String get tuningLatency => 'Zakasnitev dotika';

  @override
  String get tuningStartSpeed => 'Začetna hitrost';

  @override
  String get tuningCueLead => 'Predhod kroga';

  @override
  String get tuningDeltaHelp =>
      'Δ v zgornjem desnem kotu vožnje = odmik zadnje sprostitve od roba (− zgodaj, + pozno).';

  @override
  String get avatarBeanie => 'Kapa';

  @override
  String get avatarDreads => 'Dredi';

  @override
  String get avatarHelmet => 'Čelada';

  @override
  String get avatarKid => 'Malček';
}
