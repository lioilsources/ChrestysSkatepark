// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class L10nSk extends L10n {
  L10nSk([String locale = 'sk']) : super(locale);

  @override
  String get tapToRide => 'ŤUKNI A JAZDI';

  @override
  String dailyTrick(String trick) {
    return 'TRIK DŇA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ŠTÝL: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'KOMIKS';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'JAZDI!  $seconds';
  }

  @override
  String get wrongTrick => 'ZLÝ TRIK';

  @override
  String get tooEarly => 'PRÍLIŠ SKORO';

  @override
  String get waitForCircle => 'počkaj na kruh';

  @override
  String get noTrick => 'BEZ TRIKU';

  @override
  String get losingSpeed => 'strácaš rýchlosť';

  @override
  String get bailTiming => 'zlé načasovanie';

  @override
  String get bailUnknown => 'neznámy trik';

  @override
  String get bailTooLong => 'trik sa nezmestil do airu';

  @override
  String get outOfSpeed => 'DOŠLA RÝCHLOSŤ';

  @override
  String get rideOver => 'KONIEC JAZDY';

  @override
  String get bestTrick => 'NAJLEPŠÍ TRIK';

  @override
  String get longestCombo => 'NAJDLHŠIE COMBO';

  @override
  String get tricksLanded => 'TRIKOV';

  @override
  String get avgTiming => 'PRIEMERNÝ TIMING';

  @override
  String get tapToContinue => 'ŤUKNI PRE POKRAČOVANIE';

  @override
  String get tabGrabs => 'GRABY';

  @override
  String get tabFlips => 'FLIPY';

  @override
  String get tabSpins => 'SPINY';

  @override
  String get tabCombos => 'KOMBÁ';

  @override
  String get trickBookHelp =>
      'Po obvode = spin (v smere hodín FS, proti BS) · cez stred = grab · kosoštvorec = flip. Spoj triky jedným ťahom – ďalší začína tam, kde predchádzajúci skončil. Pusti prst, keď kruh dosadne na hranu.';

  @override
  String get spinNote => 'začni kdekoľvek na okraji';

  @override
  String pointsShort(int points) {
    return '$points b';
  }

  @override
  String get tuningTitle => 'LADENIE (M0)';

  @override
  String get tuningWindow => 'Šírka timing okna';

  @override
  String get tuningLatency => 'Latencia dotyku';

  @override
  String get tuningStartSpeed => 'Štartovacia rýchlosť';

  @override
  String get tuningCueLead => 'Predstih kruhu';

  @override
  String get tuningDeltaHelp =>
      'Δ v pravom hornom rohu jazdy = odchýlka posledného pustenia od hrany (− skoro, + neskoro).';

  @override
  String get avatarBeanie => 'Čiapka';

  @override
  String get avatarDreads => 'Dredy';

  @override
  String get avatarHelmet => 'Prilba';

  @override
  String get avatarKid => 'Drobec';
}
