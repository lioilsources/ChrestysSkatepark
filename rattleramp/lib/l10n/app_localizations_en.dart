// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get tapToRide => 'TAP TO RIDE';

  @override
  String dailyTrick(String trick) {
    return 'TRICK OF THE DAY: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'STYLE: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'COMIC';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'GO!  $seconds';
  }

  @override
  String get wrongTrick => 'WRONG TRICK';

  @override
  String get tooEarly => 'TOO EARLY';

  @override
  String get waitForCircle => 'wait for the circle';

  @override
  String get noTrick => 'NO TRICK';

  @override
  String get losingSpeed => 'you\'re losing speed';

  @override
  String get bailTiming => 'bad timing';

  @override
  String get bailUnknown => 'unknown trick';

  @override
  String get bailTooLong => 'the trick didn\'t fit in the air';

  @override
  String get outOfSpeed => 'OUT OF SPEED';

  @override
  String get rideOver => 'RIDE OVER';

  @override
  String get bestTrick => 'BEST TRICK';

  @override
  String get longestCombo => 'LONGEST COMBO';

  @override
  String get tricksLanded => 'TRICKS';

  @override
  String get avgTiming => 'AVERAGE TIMING';

  @override
  String get tapToContinue => 'TAP TO CONTINUE';

  @override
  String get tabGrabs => 'GRABS';

  @override
  String get tabFlips => 'FLIPS';

  @override
  String get tabSpins => 'SPINS';

  @override
  String get tabCombos => 'COMBOS';

  @override
  String get trickBookHelp =>
      'Around the edge = spin (clockwise FS, counter-clockwise BS) · through the centre = grab · diamond = flip. Chain tricks in one stroke – the next one starts where the last one ended. Lift your finger when the circle lands on the edge.';

  @override
  String get spinNote => 'start anywhere on the edge';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'TUNING (M0)';

  @override
  String get tuningWindow => 'Timing window width';

  @override
  String get tuningLatency => 'Touch latency';

  @override
  String get tuningStartSpeed => 'Start speed';

  @override
  String get tuningCueLead => 'Circle lead time';

  @override
  String get tuningDeltaHelp =>
      'Δ in the top-right corner of the ride = offset of the last release from the edge (− early, + late).';

  @override
  String get avatarBeanie => 'Beanie';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Helmet';

  @override
  String get avatarKid => 'Shorty';
}
