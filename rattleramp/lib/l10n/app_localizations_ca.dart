// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class L10nCa extends L10n {
  L10nCa([String locale = 'ca']) : super(locale);

  @override
  String get tapToRide => 'TOCA I PATINA';

  @override
  String dailyTrick(String trick) {
    return 'TRUC DEL DIA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ESTIL: $style';
  }

  @override
  String get styleNeon => 'NEÓ';

  @override
  String get styleComic => 'CÒMIC';

  @override
  String get stylePixel => 'PÍXEL';

  @override
  String goCountdown(int seconds) {
    return 'SOM-HI!  $seconds';
  }

  @override
  String get wrongTrick => 'TRUC INCORRECTE';

  @override
  String get tooEarly => 'MASSA AVIAT';

  @override
  String get waitForCircle => 'espera el cercle';

  @override
  String get noTrick => 'SENSE TRUC';

  @override
  String get losingSpeed => 'perds velocitat';

  @override
  String get bailTiming => 'mal timing';

  @override
  String get bailUnknown => 'truc desconegut';

  @override
  String get bailTooLong => 'el truc no ha cabut a l\'aire';

  @override
  String get outOfSpeed => 'SENSE VELOCITAT';

  @override
  String get rideOver => 'FI DE LA SESSIÓ';

  @override
  String get bestTrick => 'MILLOR TRUC';

  @override
  String get longestCombo => 'COMBO MÉS LLARG';

  @override
  String get tricksLanded => 'TRUCS';

  @override
  String get avgTiming => 'TIMING MITJÀ';

  @override
  String get tapToContinue => 'TOCA PER CONTINUAR';

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
      'Per la vora = spin (horari FS, antihorari BS) · pel centre = grab · rombe = flip. Encadena trucs d\'un sol traç: el següent comença on ha acabat l\'anterior. Deixa anar el dit quan el cercle arribi a la vora.';

  @override
  String get spinNote => 'comença a qualsevol punt de la vora';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'AJUSTOS (M0)';

  @override
  String get tuningWindow => 'Amplada de la finestra de timing';

  @override
  String get tuningLatency => 'Latència tàctil';

  @override
  String get tuningStartSpeed => 'Velocitat inicial';

  @override
  String get tuningCueLead => 'Antelació del cercle';

  @override
  String get tuningDeltaHelp =>
      'Δ a dalt a la dreta = desviació de l\'última deixada respecte a la vora (− aviat, + tard).';

  @override
  String get avatarBeanie => 'Gorra';

  @override
  String get avatarDreads => 'Rastes';

  @override
  String get avatarHelmet => 'Casc';

  @override
  String get avatarKid => 'Petitó';
}
