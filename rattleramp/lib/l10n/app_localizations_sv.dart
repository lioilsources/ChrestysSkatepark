// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class L10nSv extends L10n {
  L10nSv([String locale = 'sv']) : super(locale);

  @override
  String get tapToRide => 'TRYCK OCH ÅK';

  @override
  String dailyTrick(String trick) {
    return 'DAGENS TRICK: $trick ×2';
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
  String get styleComic => 'SERIE';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'ÅK!  $seconds';
  }

  @override
  String get wrongTrick => 'FEL TRICK';

  @override
  String get tooEarly => 'FÖR TIDIGT';

  @override
  String get waitForCircle => 'vänta på cirkeln';

  @override
  String get noTrick => 'INGET TRICK';

  @override
  String get losingSpeed => 'du tappar fart';

  @override
  String get bailTiming => 'dålig timing';

  @override
  String get bailUnknown => 'okänt trick';

  @override
  String get bailTooLong => 'tricket fick inte plats i luften';

  @override
  String get outOfSpeed => 'SLUT PÅ FART';

  @override
  String get rideOver => 'ÅKET ÄR SLUT';

  @override
  String get bestTrick => 'BÄSTA TRICK';

  @override
  String get longestCombo => 'LÄNGSTA COMBO';

  @override
  String get tricksLanded => 'TRICK';

  @override
  String get avgTiming => 'GENOMSNITTLIG TIMING';

  @override
  String get tapToContinue => 'TRYCK FÖR ATT FORTSÄTTA';

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
      'Längs kanten = spin (medurs FS, moturs BS) · genom mitten = grab · romb = flip. Länka trick i ett drag – nästa börjar där det förra slutade. Släpp fingret när cirkeln når kanten.';

  @override
  String get spinNote => 'börja var som helst på kanten';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'INSTÄLLNING (M0)';

  @override
  String get tuningWindow => 'Bredd på timingfönster';

  @override
  String get tuningLatency => 'Pekfördröjning';

  @override
  String get tuningStartSpeed => 'Startfart';

  @override
  String get tuningCueLead => 'Cirkelns försprång';

  @override
  String get tuningDeltaHelp => 'Δ uppe till höger = avvikelse för senaste släppet från kanten (− tidigt, + sent).';

  @override
  String get avatarBeanie => 'Mössa';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Hjälm';

  @override
  String get avatarKid => 'Knatten';
}
