// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class L10nRu extends L10n {
  L10nRu([String locale = 'ru']) : super(locale);

  @override
  String get tapToRide => 'НАЖМИ И ПОЕХАЛИ';

  @override
  String dailyTrick(String trick) {
    return 'ТРЮК ДНЯ: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1,5';

  @override
  String styleButton(String style) {
    return 'СТИЛЬ: $style';
  }

  @override
  String get styleNeon => 'НЕОН';

  @override
  String get styleComic => 'КОМИКС';

  @override
  String get stylePixel => 'ПИКСЕЛЬ';

  @override
  String goCountdown(int seconds) {
    return 'ПОЕХАЛИ!  $seconds';
  }

  @override
  String get wrongTrick => 'НЕВЕРНЫЙ ТРЮК';

  @override
  String get tooEarly => 'СЛИШКОМ РАНО';

  @override
  String get waitForCircle => 'дождись круга';

  @override
  String get noTrick => 'БЕЗ ТРЮКА';

  @override
  String get losingSpeed => 'ты теряешь скорость';

  @override
  String get bailTiming => 'плохой тайминг';

  @override
  String get bailUnknown => 'неизвестный трюк';

  @override
  String get bailTooLong => 'трюк не уложился в эйр';

  @override
  String get outOfSpeed => 'СКОРОСТЬ КОНЧИЛАСЬ';

  @override
  String get rideOver => 'ЗАЕЗД ОКОНЧЕН';

  @override
  String get bestTrick => 'ЛУЧШИЙ ТРЮК';

  @override
  String get longestCombo => 'САМОЕ ДЛИННОЕ КОМБО';

  @override
  String get tricksLanded => 'ТРЮКОВ';

  @override
  String get avgTiming => 'СРЕДНИЙ ТАЙМИНГ';

  @override
  String get tapToContinue => 'НАЖМИ, ЧТОБЫ ПРОДОЛЖИТЬ';

  @override
  String get tabGrabs => 'ГРЭБЫ';

  @override
  String get tabFlips => 'ФЛИПЫ';

  @override
  String get tabSpins => 'СПИНЫ';

  @override
  String get tabCombos => 'КОМБО';

  @override
  String get trickBookHelp =>
      'По краю = спин (по часовой FS, против BS) · через центр = грэб · ромб = флип. Соединяй трюки одним движением – следующий начинается там, где закончился предыдущий. Отпусти палец, когда круг коснётся края.';

  @override
  String get spinNote => 'начни в любой точке края';

  @override
  String pointsShort(int points) {
    return '$points очк.';
  }

  @override
  String get tuningTitle => 'НАСТРОЙКА (M0)';

  @override
  String get tuningWindow => 'Ширина окна тайминга';

  @override
  String get tuningLatency => 'Задержка касания';

  @override
  String get tuningStartSpeed => 'Стартовая скорость';

  @override
  String get tuningCueLead => 'Опережение круга';

  @override
  String get tuningDeltaHelp =>
      'Δ в правом верхнем углу = отклонение последнего отпускания от края (− рано, + поздно).';

  @override
  String get avatarBeanie => 'Шапка';

  @override
  String get avatarDreads => 'Дреды';

  @override
  String get avatarHelmet => 'Шлем';

  @override
  String get avatarKid => 'Малой';
}
