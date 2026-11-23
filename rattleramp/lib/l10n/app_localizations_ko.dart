// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class L10nKo extends L10n {
  L10nKo([String locale = 'ko']) : super(locale);

  @override
  String get tapToRide => '탭하고 출발';

  @override
  String dailyTrick(String trick) {
    return '오늘의 트릭: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return '스타일: $style';
  }

  @override
  String get styleNeon => '네온';

  @override
  String get styleComic => '코믹';

  @override
  String get stylePixel => '픽셀';

  @override
  String goCountdown(int seconds) {
    return '출발!  $seconds';
  }

  @override
  String get wrongTrick => '잘못된 트릭';

  @override
  String get tooEarly => '너무 빨라요';

  @override
  String get waitForCircle => '원을 기다리세요';

  @override
  String get noTrick => '트릭 없음';

  @override
  String get losingSpeed => '속도가 줄고 있어요';

  @override
  String get bailTiming => '타이밍 실패';

  @override
  String get bailUnknown => '알 수 없는 트릭';

  @override
  String get bailTooLong => '트릭이 공중에서 끝나지 않았어요';

  @override
  String get outOfSpeed => '속도 소진';

  @override
  String get rideOver => '라이드 종료';

  @override
  String get bestTrick => '최고 트릭';

  @override
  String get longestCombo => '최장 콤보';

  @override
  String get tricksLanded => '트릭 수';

  @override
  String get avgTiming => '평균 타이밍';

  @override
  String get tapToContinue => '탭하여 계속';

  @override
  String get tabGrabs => '그랩';

  @override
  String get tabFlips => '플립';

  @override
  String get tabSpins => '스핀';

  @override
  String get tabCombos => '콤보';

  @override
  String get trickBookHelp =>
      '가장자리를 따라 = 스핀 (시계 방향 FS, 반시계 방향 BS) · 가운데를 지나 = 그랩 · 마름모 = 플립. 트릭을 한 번에 이어 그리세요 – 다음 트릭은 이전 트릭이 끝난 곳에서 시작합니다. 원이 모서리에 닿을 때 손가락을 떼세요.';

  @override
  String get spinNote => '가장자리 어디에서나 시작';

  @override
  String pointsShort(int points) {
    return '$points점';
  }

  @override
  String get tuningTitle => '튜닝 (M0)';

  @override
  String get tuningWindow => '타이밍 창 너비';

  @override
  String get tuningLatency => '터치 지연';

  @override
  String get tuningStartSpeed => '시작 속도';

  @override
  String get tuningCueLead => '원 선행 시간';

  @override
  String get tuningDeltaHelp => '라이드 중 오른쪽 위 Δ = 마지막 손 뗀 시점과 모서리의 차이 (− 빠름, + 늦음).';

  @override
  String get avatarBeanie => '비니';

  @override
  String get avatarDreads => '드레드';

  @override
  String get avatarHelmet => '헬멧';

  @override
  String get avatarKid => '꼬마';
}
