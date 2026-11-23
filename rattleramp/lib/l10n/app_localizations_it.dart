// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class L10nIt extends L10n {
  L10nIt([String locale = 'it']) : super(locale);

  @override
  String get tapToRide => 'TOCCA E PARTI';

  @override
  String dailyTrick(String trick) {
    return 'TRICK DEL GIORNO: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'STILE: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'FUMETTO';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'VAI!  $seconds';
  }

  @override
  String get wrongTrick => 'TRICK SBAGLIATO';

  @override
  String get tooEarly => 'TROPPO PRESTO';

  @override
  String get waitForCircle => 'aspetta il cerchio';

  @override
  String get noTrick => 'NESSUN TRICK';

  @override
  String get losingSpeed => 'stai perdendo velocità';

  @override
  String get bailTiming => 'tempismo sbagliato';

  @override
  String get bailUnknown => 'trick sconosciuto';

  @override
  String get bailTooLong => 'il trick non è entrato nell\'air';

  @override
  String get outOfSpeed => 'VELOCITÀ FINITA';

  @override
  String get rideOver => 'FINE CORSA';

  @override
  String get bestTrick => 'MIGLIOR TRICK';

  @override
  String get longestCombo => 'COMBO PIÙ LUNGA';

  @override
  String get tricksLanded => 'TRICK';

  @override
  String get avgTiming => 'TEMPISMO MEDIO';

  @override
  String get tapToContinue => 'TOCCA PER CONTINUARE';

  @override
  String get tabGrabs => 'GRAB';

  @override
  String get tabFlips => 'FLIP';

  @override
  String get tabSpins => 'SPIN';

  @override
  String get tabCombos => 'COMBO';

  @override
  String get trickBookHelp =>
      'Lungo il bordo = spin (orario FS, antiorario BS) · al centro = grab · rombo = flip. Concatena i trick in un solo tratto: il successivo parte dove è finito il precedente. Stacca il dito quando il cerchio tocca il bordo.';

  @override
  String get spinNote => 'inizia in qualsiasi punto del bordo';

  @override
  String pointsShort(int points) {
    return '$points pt';
  }

  @override
  String get tuningTitle => 'TARATURA (M0)';

  @override
  String get tuningWindow => 'Ampiezza della finestra di timing';

  @override
  String get tuningLatency => 'Latenza del tocco';

  @override
  String get tuningStartSpeed => 'Velocità iniziale';

  @override
  String get tuningCueLead => 'Anticipo del cerchio';

  @override
  String get tuningDeltaHelp =>
      'Δ in alto a destra = scarto dell\'ultimo rilascio rispetto al bordo (− presto, + tardi).';

  @override
  String get avatarBeanie => 'Berretto';

  @override
  String get avatarDreads => 'Dread';

  @override
  String get avatarHelmet => 'Casco';

  @override
  String get avatarKid => 'Piccoletto';
}
