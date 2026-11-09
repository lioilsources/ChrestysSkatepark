// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class L10nDa extends L10n {
  L10nDa([String locale = 'da']) : super(locale);

  @override
  String get tapToRide => 'TRYK OG KØR';

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
  String get styleComic => 'TEGNESERIE';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'KØR!  $seconds';
  }

  @override
  String get wrongTrick => 'FORKERT TRICK';

  @override
  String get tooEarly => 'FOR TIDLIGT';

  @override
  String get waitForCircle => 'vent på cirklen';

  @override
  String get noTrick => 'INTET TRICK';

  @override
  String get losingSpeed => 'du mister fart';

  @override
  String get bailTiming => 'dårlig timing';

  @override
  String get bailUnknown => 'ukendt trick';

  @override
  String get bailTooLong => 'tricket kunne ikke nås i luften';

  @override
  String get outOfSpeed => 'INGEN FART';

  @override
  String get rideOver => 'TUREN ER SLUT';

  @override
  String get bestTrick => 'BEDSTE TRICK';

  @override
  String get longestCombo => 'LÆNGSTE COMBO';

  @override
  String get tricksLanded => 'TRICKS';

  @override
  String get avgTiming => 'GENNEMSNITLIG TIMING';

  @override
  String get tapToContinue => 'TRYK FOR AT FORTSÆTTE';

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
      'Langs kanten = spin (med uret FS, mod uret BS) · gennem midten = grab · rombe = flip. Sæt tricks sammen i ét strøg – det næste starter, hvor det forrige sluttede. Slip fingeren, når cirklen rammer kanten.';

  @override
  String get spinNote => 'start hvor som helst på kanten';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'JUSTERING (M0)';

  @override
  String get tuningWindow => 'Bredde på timingvindue';

  @override
  String get tuningLatency => 'Berøringsforsinkelse';

  @override
  String get tuningStartSpeed => 'Startfart';

  @override
  String get tuningCueLead => 'Cirklens forspring';

  @override
  String get tuningDeltaHelp => 'Δ øverst til højre = afvigelse for sidste slip fra kanten (− tidligt, + sent).';

  @override
  String get avatarBeanie => 'Hue';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Hjelm';

  @override
  String get avatarKid => 'Lillemand';
}
