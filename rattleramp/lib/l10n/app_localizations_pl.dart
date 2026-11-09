// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class L10nPl extends L10n {
  L10nPl([String locale = 'pl']) : super(locale);

  @override
  String get tapToRide => 'DOTKNIJ I JEDŹ';

  @override
  String dailyTrick(String trick) {
    return 'TRIK DNIA: $trick ×2';
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
  String get stylePixel => 'PIKSEL';

  @override
  String goCountdown(int seconds) {
    return 'JEDŹ!  $seconds';
  }

  @override
  String get wrongTrick => 'ZŁY TRIK';

  @override
  String get tooEarly => 'ZA WCZEŚNIE';

  @override
  String get waitForCircle => 'poczekaj na okrąg';

  @override
  String get noTrick => 'BEZ TRIKU';

  @override
  String get losingSpeed => 'tracisz prędkość';

  @override
  String get bailTiming => 'złe wyczucie czasu';

  @override
  String get bailUnknown => 'nieznany trik';

  @override
  String get bailTooLong => 'trik nie zmieścił się w locie';

  @override
  String get outOfSpeed => 'KONIEC PRĘDKOŚCI';

  @override
  String get rideOver => 'KONIEC JAZDY';

  @override
  String get bestTrick => 'NAJLEPSZY TRIK';

  @override
  String get longestCombo => 'NAJDŁUŻSZE COMBO';

  @override
  String get tricksLanded => 'TRIKI';

  @override
  String get avgTiming => 'ŚREDNI TIMING';

  @override
  String get tapToContinue => 'DOTKNIJ, ABY KONTYNUOWAĆ';

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
      'Po obwodzie = spin (zgodnie z ruchem wskazówek zegara FS, przeciwnie BS) · przez środek = grab · romb = flip. Łącz triki jednym ruchem – kolejny zaczyna się tam, gdzie skończył poprzedni. Puść palec, gdy okrąg dotknie krawędzi.';

  @override
  String get spinNote => 'zacznij w dowolnym miejscu krawędzi';

  @override
  String pointsShort(int points) {
    return '$points pkt';
  }

  @override
  String get tuningTitle => 'STROJENIE (M0)';

  @override
  String get tuningWindow => 'Szerokość okna timingu';

  @override
  String get tuningLatency => 'Opóźnienie dotyku';

  @override
  String get tuningStartSpeed => 'Prędkość startowa';

  @override
  String get tuningCueLead => 'Wyprzedzenie okręgu';

  @override
  String get tuningDeltaHelp =>
      'Δ w prawym górnym rogu jazdy = odchyłka ostatniego puszczenia od krawędzi (− wcześnie, + późno).';

  @override
  String get avatarBeanie => 'Czapka';

  @override
  String get avatarDreads => 'Dredy';

  @override
  String get avatarHelmet => 'Kask';

  @override
  String get avatarKid => 'Maluch';
}
