// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class L10nDe extends L10n {
  L10nDe([String locale = 'de']) : super(locale);

  @override
  String get tapToRide => 'TIPPEN UND LOSFAHREN';

  @override
  String dailyTrick(String trick) {
    return 'TRICK DES TAGES: $trick ×2';
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
  String get styleComic => 'COMIC';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'LOS!  $seconds';
  }

  @override
  String get wrongTrick => 'FALSCHER TRICK';

  @override
  String get tooEarly => 'ZU FRÜH';

  @override
  String get waitForCircle => 'warte auf den Kreis';

  @override
  String get noTrick => 'KEIN TRICK';

  @override
  String get losingSpeed => 'du verlierst Tempo';

  @override
  String get bailTiming => 'schlechtes Timing';

  @override
  String get bailUnknown => 'unbekannter Trick';

  @override
  String get bailTooLong => 'der Trick passte nicht in den Air';

  @override
  String get outOfSpeed => 'KEIN TEMPO MEHR';

  @override
  String get rideOver => 'FAHRT VORBEI';

  @override
  String get bestTrick => 'BESTER TRICK';

  @override
  String get longestCombo => 'LÄNGSTE COMBO';

  @override
  String get tricksLanded => 'TRICKS';

  @override
  String get avgTiming => 'DURCHSCHNITTLICHES TIMING';

  @override
  String get tapToContinue => 'TIPPEN ZUM FORTFAHREN';

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
      'Am Rand entlang = Spin (im Uhrzeigersinn FS, dagegen BS) · durch die Mitte = Grab · Raute = Flip. Verbinde Tricks in einem Zug – der nächste beginnt, wo der vorige endete. Lass los, wenn der Kreis die Kante erreicht.';

  @override
  String get spinNote => 'beginne irgendwo am Rand';

  @override
  String pointsShort(int points) {
    return '$points P.';
  }

  @override
  String get tuningTitle => 'TUNING (M0)';

  @override
  String get tuningWindow => 'Breite des Timing-Fensters';

  @override
  String get tuningLatency => 'Touch-Latenz';

  @override
  String get tuningStartSpeed => 'Starttempo';

  @override
  String get tuningCueLead => 'Vorlauf des Kreises';

  @override
  String get tuningDeltaHelp =>
      'Δ oben rechts während der Fahrt = Abweichung des letzten Loslassens von der Kante (− früh, + spät).';

  @override
  String get avatarBeanie => 'Mütze';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Helm';

  @override
  String get avatarKid => 'Knirps';
}
