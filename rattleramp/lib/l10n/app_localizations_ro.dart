// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class L10nRo extends L10n {
  L10nRo([String locale = 'ro']) : super(locale);

  @override
  String get tapToRide => 'ATINGE ȘI PLEACĂ';

  @override
  String dailyTrick(String trick) {
    return 'TRUCUL ZILEI: $trick ×2';
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
  String get styleComic => 'BENZI DESENATE';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'PLEACĂ!  $seconds';
  }

  @override
  String get wrongTrick => 'TRUC GREȘIT';

  @override
  String get tooEarly => 'PREA DEVREME';

  @override
  String get waitForCircle => 'așteaptă cercul';

  @override
  String get noTrick => 'FĂRĂ TRUC';

  @override
  String get losingSpeed => 'pierzi viteză';

  @override
  String get bailTiming => 'sincronizare proastă';

  @override
  String get bailUnknown => 'truc necunoscut';

  @override
  String get bailTooLong => 'trucul nu a încăput în săritură';

  @override
  String get outOfSpeed => 'FĂRĂ VITEZĂ';

  @override
  String get rideOver => 'CURSĂ TERMINATĂ';

  @override
  String get bestTrick => 'CEL MAI BUN TRUC';

  @override
  String get longestCombo => 'CEL MAI LUNG COMBO';

  @override
  String get tricksLanded => 'TRUCURI';

  @override
  String get avgTiming => 'SINCRONIZARE MEDIE';

  @override
  String get tapToContinue => 'ATINGE PENTRU A CONTINUA';

  @override
  String get tabGrabs => 'GRABURI';

  @override
  String get tabFlips => 'FLIPURI';

  @override
  String get tabSpins => 'SPINURI';

  @override
  String get tabCombos => 'COMBO-URI';

  @override
  String get trickBookHelp =>
      'Pe margine = spin (în sensul acelor de ceasornic FS, invers BS) · prin centru = grab · romb = flip. Leagă trucurile dintr-o singură mișcare – următorul începe unde s-a terminat cel dinainte. Ridică degetul când cercul atinge muchia.';

  @override
  String get spinNote => 'începe oriunde pe margine';

  @override
  String pointsShort(int points) {
    return '$points p';
  }

  @override
  String get tuningTitle => 'REGLAJ (M0)';

  @override
  String get tuningWindow => 'Lățimea ferestrei de sincronizare';

  @override
  String get tuningLatency => 'Latența atingerii';

  @override
  String get tuningStartSpeed => 'Viteza de start';

  @override
  String get tuningCueLead => 'Avansul cercului';

  @override
  String get tuningDeltaHelp =>
      'Δ în colțul din dreapta sus = abaterea ultimei eliberări față de muchie (− devreme, + târziu).';

  @override
  String get avatarBeanie => 'Căciulă';

  @override
  String get avatarDreads => 'Dreaduri';

  @override
  String get avatarHelmet => 'Cască';

  @override
  String get avatarKid => 'Piticul';
}
