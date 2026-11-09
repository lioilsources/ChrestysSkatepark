// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class L10nNl extends L10n {
  L10nNl([String locale = 'nl']) : super(locale);

  @override
  String get tapToRide => 'TIK EN RIJD';

  @override
  String dailyTrick(String trick) {
    return 'TRUC VAN DE DAG: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STIJL: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'STRIP';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'GO!  $seconds';
  }

  @override
  String get wrongTrick => 'VERKEERDE TRUC';

  @override
  String get tooEarly => 'TE VROEG';

  @override
  String get waitForCircle => 'wacht op de cirkel';

  @override
  String get noTrick => 'GEEN TRUC';

  @override
  String get losingSpeed => 'je verliest snelheid';

  @override
  String get bailTiming => 'slechte timing';

  @override
  String get bailUnknown => 'onbekende truc';

  @override
  String get bailTooLong => 'de truc paste niet in de air';

  @override
  String get outOfSpeed => 'GEEN SNELHEID MEER';

  @override
  String get rideOver => 'RIT VOORBIJ';

  @override
  String get bestTrick => 'BESTE TRUC';

  @override
  String get longestCombo => 'LANGSTE COMBO';

  @override
  String get tricksLanded => 'TRUCS';

  @override
  String get avgTiming => 'GEMIDDELDE TIMING';

  @override
  String get tapToContinue => 'TIK OM DOOR TE GAAN';

  @override
  String get tabGrabs => 'GRABS';

  @override
  String get tabFlips => 'FLIPS';

  @override
  String get tabSpins => 'SPINS';

  @override
  String get tabCombos => 'COMBO\'S';

  @override
  String get trickBookHelp =>
      'Langs de rand = spin (met de klok mee FS, tegen de klok in BS) · door het midden = grab · ruit = flip. Rijg trucs aan elkaar in één streek – de volgende begint waar de vorige eindigde. Laat los als de cirkel de rand raakt.';

  @override
  String get spinNote => 'begin ergens op de rand';

  @override
  String pointsShort(int points) {
    return '$points ptn';
  }

  @override
  String get tuningTitle => 'AFSTELLEN (M0)';

  @override
  String get tuningWindow => 'Breedte van het timingvenster';

  @override
  String get tuningLatency => 'Aanraakvertraging';

  @override
  String get tuningStartSpeed => 'Startsnelheid';

  @override
  String get tuningCueLead => 'Voorsprong van de cirkel';

  @override
  String get tuningDeltaHelp =>
      'Δ rechtsboven tijdens de rit = afwijking van het laatste loslaten ten opzichte van de rand (− vroeg, + laat).';

  @override
  String get avatarBeanie => 'Muts';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Helm';

  @override
  String get avatarKid => 'Kleintje';
}
