// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class L10nEs extends L10n {
  L10nEs([String locale = 'es']) : super(locale);

  @override
  String get tapToRide => 'TOCA Y PATINA';

  @override
  String dailyTrick(String trick) {
    return 'TRUCO DEL DÍA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ESTILO: $style';
  }

  @override
  String get styleNeon => 'NEÓN';

  @override
  String get styleComic => 'CÓMIC';

  @override
  String get stylePixel => 'PÍXEL';

  @override
  String goCountdown(int seconds) {
    return '¡VAMOS!  $seconds';
  }

  @override
  String get wrongTrick => 'TRUCO INCORRECTO';

  @override
  String get tooEarly => 'DEMASIADO PRONTO';

  @override
  String get waitForCircle => 'espera al círculo';

  @override
  String get noTrick => 'SIN TRUCO';

  @override
  String get losingSpeed => 'pierdes velocidad';

  @override
  String get bailTiming => 'mal timing';

  @override
  String get bailUnknown => 'truco desconocido';

  @override
  String get bailTooLong => 'el truco no cupo en el aire';

  @override
  String get outOfSpeed => 'SIN VELOCIDAD';

  @override
  String get rideOver => 'FIN DE LA SESIÓN';

  @override
  String get bestTrick => 'MEJOR TRUCO';

  @override
  String get longestCombo => 'COMBO MÁS LARGO';

  @override
  String get tricksLanded => 'TRUCOS';

  @override
  String get avgTiming => 'TIMING MEDIO';

  @override
  String get tapToContinue => 'TOCA PARA CONTINUAR';

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
      'Por el borde = spin (horario FS, antihorario BS) · por el centro = grab · rombo = flip. Encadena trucos de un solo trazo: el siguiente empieza donde terminó el anterior. Suelta el dedo cuando el círculo llegue al borde.';

  @override
  String get spinNote => 'empieza en cualquier punto del borde';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'AJUSTES (M0)';

  @override
  String get tuningWindow => 'Ancho de la ventana de timing';

  @override
  String get tuningLatency => 'Latencia táctil';

  @override
  String get tuningStartSpeed => 'Velocidad inicial';

  @override
  String get tuningCueLead => 'Antelación del círculo';

  @override
  String get tuningDeltaHelp =>
      'Δ arriba a la derecha = desviación de la última suelta respecto al borde (− pronto, + tarde).';

  @override
  String get avatarBeanie => 'Gorro';

  @override
  String get avatarDreads => 'Rastas';

  @override
  String get avatarHelmet => 'Casco';

  @override
  String get avatarKid => 'Peque';
}
