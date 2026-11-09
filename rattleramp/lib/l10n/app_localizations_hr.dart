// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class L10nHr extends L10n {
  L10nHr([String locale = 'hr']) : super(locale);

  @override
  String get tapToRide => 'DODIRNI I VOZI';

  @override
  String dailyTrick(String trick) {
    return 'TRIK DANA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STIL: $style';
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
  String get wrongTrick => 'KRIVI TRIK';

  @override
  String get tooEarly => 'PRERANO';

  @override
  String get waitForCircle => 'pričekaj krug';

  @override
  String get noTrick => 'BEZ TRIKA';

  @override
  String get losingSpeed => 'gubiš brzinu';

  @override
  String get bailTiming => 'loš tajming';

  @override
  String get bailUnknown => 'nepoznat trik';

  @override
  String get bailTooLong => 'trik nije stao u skok';

  @override
  String get outOfSpeed => 'NESTALO BRZINE';

  @override
  String get rideOver => 'KRAJ VOŽNJE';

  @override
  String get bestTrick => 'NAJBOLJI TRIK';

  @override
  String get longestCombo => 'NAJDULJI COMBO';

  @override
  String get tricksLanded => 'TRIKOVA';

  @override
  String get avgTiming => 'PROSJEČNI TAJMING';

  @override
  String get tapToContinue => 'DODIRNI ZA NASTAVAK';

  @override
  String get tabGrabs => 'GRABOVI';

  @override
  String get tabFlips => 'FLIPOVI';

  @override
  String get tabSpins => 'SPINOVI';

  @override
  String get tabCombos => 'KOMBINACIJE';

  @override
  String get trickBookHelp =>
      'Po rubu = spin (u smjeru kazaljke na satu FS, suprotno BS) · kroz sredinu = grab · romb = flip. Spoji trikove jednim potezom – sljedeći počinje gdje je prethodni završio. Pusti prst kad krug dosegne rub.';

  @override
  String get spinNote => 'počni bilo gdje na rubu';

  @override
  String pointsShort(int points) {
    return '$points b';
  }

  @override
  String get tuningTitle => 'PODEŠAVANJE (M0)';

  @override
  String get tuningWindow => 'Širina vremenskog prozora';

  @override
  String get tuningLatency => 'Kašnjenje dodira';

  @override
  String get tuningStartSpeed => 'Početna brzina';

  @override
  String get tuningCueLead => 'Prednost kruga';

  @override
  String get tuningDeltaHelp =>
      'Δ u gornjem desnom kutu vožnje = odstupanje zadnjeg otpuštanja od ruba (− rano, + kasno).';

  @override
  String get avatarBeanie => 'Kapa';

  @override
  String get avatarDreads => 'Dredovi';

  @override
  String get avatarHelmet => 'Kaciga';

  @override
  String get avatarKid => 'Mali';
}
