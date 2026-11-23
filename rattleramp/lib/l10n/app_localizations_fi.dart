// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class L10nFi extends L10n {
  L10nFi([String locale = 'fi']) : super(locale);

  @override
  String get tapToRide => 'NAPAUTA JA AJA';

  @override
  String dailyTrick(String trick) {
    return 'PÄIVÄN TEMPPU: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'TYYLI: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'SARJAKUVA';

  @override
  String get stylePixel => 'PIKSELI';

  @override
  String goCountdown(int seconds) {
    return 'AJA!  $seconds';
  }

  @override
  String get wrongTrick => 'VÄÄRÄ TEMPPU';

  @override
  String get tooEarly => 'LIIAN AIKAISIN';

  @override
  String get waitForCircle => 'odota ympyrää';

  @override
  String get noTrick => 'EI TEMPPUA';

  @override
  String get losingSpeed => 'menetät vauhtia';

  @override
  String get bailTiming => 'huono ajoitus';

  @override
  String get bailUnknown => 'tuntematon temppu';

  @override
  String get bailTooLong => 'temppu ei mahtunut ilmaan';

  @override
  String get outOfSpeed => 'VAUHTI LOPPUI';

  @override
  String get rideOver => 'AJO PÄÄTTYI';

  @override
  String get bestTrick => 'PARAS TEMPPU';

  @override
  String get longestCombo => 'PISIN COMBO';

  @override
  String get tricksLanded => 'TEMPPUJA';

  @override
  String get avgTiming => 'KESKIMÄÄRÄINEN AJOITUS';

  @override
  String get tapToContinue => 'NAPAUTA JATKAAKSESI';

  @override
  String get tabGrabs => 'GRABIT';

  @override
  String get tabFlips => 'FLIPIT';

  @override
  String get tabSpins => 'SPINIT';

  @override
  String get tabCombos => 'COMBOT';

  @override
  String get trickBookHelp =>
      'Reunaa pitkin = spin (myötäpäivään FS, vastapäivään BS) · keskeltä = grab · vinoneliö = flip. Yhdistä temput yhdellä vedolla – seuraava alkaa siitä, mihin edellinen päättyi. Nosta sormi, kun ympyrä osuu reunaan.';

  @override
  String get spinNote => 'aloita mistä tahansa reunalta';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'SÄÄTÖ (M0)';

  @override
  String get tuningWindow => 'Ajoitusikkunan leveys';

  @override
  String get tuningLatency => 'Kosketusviive';

  @override
  String get tuningStartSpeed => 'Lähtövauhti';

  @override
  String get tuningCueLead => 'Ympyrän ennakko';

  @override
  String get tuningDeltaHelp =>
      'Δ oikeassa yläkulmassa = viimeisen irrotuksen poikkeama reunasta (− aikaisin, + myöhään).';

  @override
  String get avatarBeanie => 'Pipo';

  @override
  String get avatarDreads => 'Dreadit';

  @override
  String get avatarHelmet => 'Kypärä';

  @override
  String get avatarKid => 'Pikkuinen';
}
