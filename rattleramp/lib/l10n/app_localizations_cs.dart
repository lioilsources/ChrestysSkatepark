// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class L10nCs extends L10n {
  L10nCs([String locale = 'cs']) : super(locale);

  @override
  String get tapToRide => 'TAPNI A JEĎ';

  @override
  String dailyTrick(String trick) {
    return 'TRIK DNE: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STYL: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'KOMIKS';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'JEĎ!  $seconds';
  }

  @override
  String get wrongTrick => 'ŠPATNÝ TRIK';

  @override
  String get tooEarly => 'MOC BRZY';

  @override
  String get waitForCircle => 'počkej na kruh';

  @override
  String get noTrick => 'BEZ TRIKU';

  @override
  String get losingSpeed => 'ztrácíš rychlost';

  @override
  String get bailTiming => 'špatné načasování';

  @override
  String get bailUnknown => 'neznámý trik';

  @override
  String get bailTooLong => 'trik se nevešel do airu';

  @override
  String get outOfSpeed => 'DOŠLA RYCHLOST';

  @override
  String get rideOver => 'KONEC JÍZDY';

  @override
  String get bestTrick => 'NEJLEPŠÍ TRIK';

  @override
  String get longestCombo => 'NEJDELŠÍ COMBO';

  @override
  String get tricksLanded => 'TRIKŮ';

  @override
  String get avgTiming => 'PRŮMĚRNÝ TIMING';

  @override
  String get tapToContinue => 'TAPNI PRO POKRAČOVÁNÍ';

  @override
  String get tabGrabs => 'GRABY';

  @override
  String get tabFlips => 'FLIPY';

  @override
  String get tabSpins => 'SPINY';

  @override
  String get tabCombos => 'KOMBA';

  @override
  String get trickBookHelp =>
      'Po obvodu = spin (po směru hodin FS, proti BS) · přes střed = grab · kosočtverec = flip. Spoj triky jedním tahem – další začíná tam, kde předchozí skončil. Pusť prst, když kruh dosedne na hranu.';

  @override
  String get spinNote => 'začni kdekoli na okraji';

  @override
  String pointsShort(int points) {
    return '$points b';
  }

  @override
  String get tuningTitle => 'LADĚNÍ (M0)';

  @override
  String get tuningWindow => 'Šířka timing okna';

  @override
  String get tuningLatency => 'Latence dotyku';

  @override
  String get tuningStartSpeed => 'Startovní rychlost';

  @override
  String get tuningCueLead => 'Předstih kruhu';

  @override
  String get tuningDeltaHelp =>
      'Δ v pravém horním rohu jízdy = odchylka posledního puštění od hrany (− brzy, + pozdě).';

  @override
  String get avatarBeanie => 'Kulich';

  @override
  String get avatarDreads => 'Dready';

  @override
  String get avatarHelmet => 'Helma';

  @override
  String get avatarKid => 'Prcek';
}
