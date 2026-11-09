// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class L10nPt extends L10n {
  L10nPt([String locale = 'pt']) : super(locale);

  @override
  String get tapToRide => 'TOCA E ANDA';

  @override
  String dailyTrick(String trick) {
    return 'TRUQUE DO DIA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ESTILO: $style';
  }

  @override
  String get styleNeon => 'NÉON';

  @override
  String get styleComic => 'BANDA DESENHADA';

  @override
  String get stylePixel => 'PÍXEL';

  @override
  String goCountdown(int seconds) {
    return 'VAI!  $seconds';
  }

  @override
  String get wrongTrick => 'TRUQUE ERRADO';

  @override
  String get tooEarly => 'DEMASIADO CEDO';

  @override
  String get waitForCircle => 'espera pelo círculo';

  @override
  String get noTrick => 'SEM TRUQUE';

  @override
  String get losingSpeed => 'estás a perder velocidade';

  @override
  String get bailTiming => 'mau timing';

  @override
  String get bailUnknown => 'truque desconhecido';

  @override
  String get bailTooLong => 'o truque não coube no ar';

  @override
  String get outOfSpeed => 'SEM VELOCIDADE';

  @override
  String get rideOver => 'FIM DA VOLTA';

  @override
  String get bestTrick => 'MELHOR TRUQUE';

  @override
  String get longestCombo => 'COMBO MAIS LONGO';

  @override
  String get tricksLanded => 'TRUQUES';

  @override
  String get avgTiming => 'TIMING MÉDIO';

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
      'Pela borda = spin (sentido horário FS, anti-horário BS) · pelo centro = grab · losango = flip. Encadeia truques num só traço – o seguinte começa onde o anterior acabou. Levanta o dedo quando o círculo chegar à borda.';

  @override
  String get spinNote => 'começa em qualquer ponto da borda';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'AFINAÇÃO (M0)';

  @override
  String get tuningWindow => 'Largura da janela de timing';

  @override
  String get tuningLatency => 'Latência do toque';

  @override
  String get tuningStartSpeed => 'Velocidade inicial';

  @override
  String get tuningCueLead => 'Antecedência do círculo';

  @override
  String get tuningDeltaHelp =>
      'Δ no canto superior direito = desvio da última largada em relação à borda (− cedo, + tarde).';

  @override
  String get avatarBeanie => 'Gorro';

  @override
  String get avatarDreads => 'Rastas';

  @override
  String get avatarHelmet => 'Capacete';

  @override
  String get avatarKid => 'Miúdo';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class L10nPtBr extends L10nPt {
  L10nPtBr() : super('pt_BR');

  @override
  String get tapToRide => 'TOQUE E ANDE';

  @override
  String dailyTrick(String trick) {
    return 'MANOBRA DO DIA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ESTILO: $style';
  }

  @override
  String get styleNeon => 'NEON';

  @override
  String get styleComic => 'QUADRINHOS';

  @override
  String get stylePixel => 'PIXEL';

  @override
  String goCountdown(int seconds) {
    return 'VAI!  $seconds';
  }

  @override
  String get wrongTrick => 'MANOBRA ERRADA';

  @override
  String get tooEarly => 'CEDO DEMAIS';

  @override
  String get waitForCircle => 'espere o círculo';

  @override
  String get noTrick => 'SEM MANOBRA';

  @override
  String get losingSpeed => 'você está perdendo velocidade';

  @override
  String get bailTiming => 'timing ruim';

  @override
  String get bailUnknown => 'manobra desconhecida';

  @override
  String get bailTooLong => 'a manobra não coube no ar';

  @override
  String get outOfSpeed => 'SEM VELOCIDADE';

  @override
  String get rideOver => 'FIM DA VOLTA';

  @override
  String get bestTrick => 'MELHOR MANOBRA';

  @override
  String get longestCombo => 'COMBO MAIS LONGO';

  @override
  String get tricksLanded => 'MANOBRAS';

  @override
  String get avgTiming => 'TIMING MÉDIO';

  @override
  String get tapToContinue => 'TOQUE PARA CONTINUAR';

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
      'Pela borda = spin (sentido horário FS, anti-horário BS) · pelo centro = grab · losango = flip. Encadeie manobras num só traço – a próxima começa onde a anterior terminou. Solte o dedo quando o círculo chegar à borda.';

  @override
  String get spinNote => 'comece em qualquer ponto da borda';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'AJUSTES (M0)';

  @override
  String get tuningWindow => 'Largura da janela de timing';

  @override
  String get tuningLatency => 'Latência do toque';

  @override
  String get tuningStartSpeed => 'Velocidade inicial';

  @override
  String get tuningCueLead => 'Antecedência do círculo';

  @override
  String get tuningDeltaHelp =>
      'Δ no canto superior direito = desvio da última soltura em relação à borda (− cedo, + tarde).';

  @override
  String get avatarBeanie => 'Gorro';

  @override
  String get avatarDreads => 'Dreads';

  @override
  String get avatarHelmet => 'Capacete';

  @override
  String get avatarKid => 'Pivete';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class L10nPtPt extends L10nPt {
  L10nPtPt() : super('pt_PT');

  @override
  String get tapToRide => 'TOCA E ANDA';

  @override
  String dailyTrick(String trick) {
    return 'TRUQUE DO DIA: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'ESTILO: $style';
  }

  @override
  String get styleNeon => 'NÉON';

  @override
  String get styleComic => 'BANDA DESENHADA';

  @override
  String get stylePixel => 'PÍXEL';

  @override
  String goCountdown(int seconds) {
    return 'VAI!  $seconds';
  }

  @override
  String get wrongTrick => 'TRUQUE ERRADO';

  @override
  String get tooEarly => 'DEMASIADO CEDO';

  @override
  String get waitForCircle => 'espera pelo círculo';

  @override
  String get noTrick => 'SEM TRUQUE';

  @override
  String get losingSpeed => 'estás a perder velocidade';

  @override
  String get bailTiming => 'mau timing';

  @override
  String get bailUnknown => 'truque desconhecido';

  @override
  String get bailTooLong => 'o truque não coube no ar';

  @override
  String get outOfSpeed => 'SEM VELOCIDADE';

  @override
  String get rideOver => 'FIM DA VOLTA';

  @override
  String get bestTrick => 'MELHOR TRUQUE';

  @override
  String get longestCombo => 'COMBO MAIS LONGO';

  @override
  String get tricksLanded => 'TRUQUES';

  @override
  String get avgTiming => 'TIMING MÉDIO';

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
      'Pela borda = spin (sentido horário FS, anti-horário BS) · pelo centro = grab · losango = flip. Encadeia truques num só traço – o seguinte começa onde o anterior acabou. Levanta o dedo quando o círculo chegar à borda.';

  @override
  String get spinNote => 'começa em qualquer ponto da borda';

  @override
  String pointsShort(int points) {
    return '$points pts';
  }

  @override
  String get tuningTitle => 'AFINAÇÃO (M0)';

  @override
  String get tuningWindow => 'Largura da janela de timing';

  @override
  String get tuningLatency => 'Latência do toque';

  @override
  String get tuningStartSpeed => 'Velocidade inicial';

  @override
  String get tuningCueLead => 'Antecedência do círculo';

  @override
  String get tuningDeltaHelp =>
      'Δ no canto superior direito = desvio da última largada em relação à borda (− cedo, + tarde).';

  @override
  String get avatarBeanie => 'Gorro';

  @override
  String get avatarDreads => 'Rastas';

  @override
  String get avatarHelmet => 'Capacete';

  @override
  String get avatarKid => 'Miúdo';
}
