// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class L10nNb extends L10n {
  L10nNb([String locale = 'nb']) : super(locale);

  @override
  String get tapToRide => 'TRYKK OG KJØR';

  @override
  String dailyTrick(String trick) {
    return 'DAGENS TRIKS: $trick ×2';
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
  String get styleComic => 'TEGNESERIE';

  @override
  String get stylePixel => 'PIKSEL';

  @override
  String goCountdown(int seconds) {
    return 'KJØR!  $seconds';
  }

  @override
  String get wrongTrick => 'FEIL TRIKS';

  @override
  String get tooEarly => 'FOR TIDLIG';

  @override
  String get waitForCircle => 'vent på sirkelen';

  @override
  String get noTrick => 'INGEN TRIKS';

  @override
  String get losingSpeed => 'du mister fart';

  @override
  String get bailTiming => 'dårlig timing';

  @override
  String get bailUnknown => 'ukjent triks';

  @override
  String get bailTooLong => 'trikset fikk ikke plass i luften';

  @override
  String get outOfSpeed => 'TOM FOR FART';

  @override
  String get rideOver => 'TUREN ER OVER';

  @override
  String get bestTrick => 'BESTE TRIKS';

  @override
  String get longestCombo => 'LENGSTE COMBO';

  @override
  String get tricksLanded => 'TRIKS';

  @override
  String get avgTiming => 'GJENNOMSNITTLIG TIMING';

  @override
  String get tapToContinue => 'TRYKK FOR Å FORTSETTE';

  @override
  String get tabGrabs => 'GRABS';

  @override
  String get tabFlips => 'FLIPS';

  @override
  String get tabSpins => 'SPINS';

  @override
  String get tabCombos => 'COMBOER';

  @override
  String get trickBookHelp =>
      'Langs kanten = spinn (med klokka FS, mot klokka BS) · gjennom midten = grab · rombe = flip. Koble triks i ett strøk – det neste starter der det forrige sluttet. Slipp fingeren når sirkelen treffer kanten.';

  @override
  String get spinNote => 'start hvor som helst på kanten';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'JUSTERING (M0)';

  @override
  String get tuningWindow => 'Bredde på timingvindu';

  @override
  String get tuningLatency => 'Berøringsforsinkelse';

  @override
  String get tuningStartSpeed => 'Startfart';

  @override
  String get tuningCueLead => 'Sirkelens forsprang';

  @override
  String get tuningDeltaHelp => 'Δ øverst til høyre = avvik for siste slipp fra kanten (− tidlig, + sent).';

  @override
  String get avatarBeanie => 'Lue';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Hjelm';

  @override
  String get avatarKid => 'Smågutt';
}
