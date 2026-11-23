// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class L10nUk extends L10n {
  L10nUk([String locale = 'uk']) : super(locale);

  @override
  String get tapToRide => 'ТОРКНИСЬ І ЇДЬ';

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
  String get styleComic => 'КОМІКС';

  @override
  String get stylePixel => 'ПІКСЕЛЬ';

  @override
  String goCountdown(int seconds) {
    return 'ЇДЬ!  $seconds';
  }

  @override
  String get wrongTrick => 'НЕПРАВИЛЬНИЙ ТРЮК';

  @override
  String get tooEarly => 'ЗАРАНО';

  @override
  String get waitForCircle => 'зачекай на коло';

  @override
  String get noTrick => 'БЕЗ ТРЮКУ';

  @override
  String get losingSpeed => 'ти втрачаєш швидкість';

  @override
  String get bailTiming => 'поганий таймінг';

  @override
  String get bailUnknown => 'невідомий трюк';

  @override
  String get bailTooLong => 'трюк не вмістився в ейр';

  @override
  String get outOfSpeed => 'ШВИДКІСТЬ СКІНЧИЛАСЬ';

  @override
  String get rideOver => 'ЗАЇЗД ЗАВЕРШЕНО';

  @override
  String get bestTrick => 'НАЙКРАЩИЙ ТРЮК';

  @override
  String get longestCombo => 'НАЙДОВШЕ КОМБО';

  @override
  String get tricksLanded => 'ТРЮКІВ';

  @override
  String get avgTiming => 'СЕРЕДНІЙ ТАЙМІНГ';

  @override
  String get tapToContinue => 'ТОРКНИСЬ, ЩОБ ПРОДОВЖИТИ';

  @override
  String get tabGrabs => 'ГРЕБИ';

  @override
  String get tabFlips => 'ФЛІПИ';

  @override
  String get tabSpins => 'СПІНИ';

  @override
  String get tabCombos => 'КОМБО';

  @override
  String get trickBookHelp =>
      'По краю = спін (за годинниковою FS, проти BS) · через центр = греб · ромб = фліп. Поєднуй трюки одним рухом – наступний починається там, де закінчився попередній. Відпусти палець, коли коло торкнеться краю.';

  @override
  String get spinNote => 'почни будь-де на краю';

  @override
  String pointsShort(int points) {
    return '$points оч.';
  }

  @override
  String get tuningTitle => 'НАЛАШТУВАННЯ (M0)';

  @override
  String get tuningWindow => 'Ширина вікна таймінгу';

  @override
  String get tuningLatency => 'Затримка дотику';

  @override
  String get tuningStartSpeed => 'Стартова швидкість';

  @override
  String get tuningCueLead => 'Випередження кола';

  @override
  String get tuningDeltaHelp =>
      'Δ у правому верхньому куті = відхилення останнього відпускання від краю (− рано, + пізно).';

  @override
  String get avatarBeanie => 'Шапка';

  @override
  String get avatarDreads => 'Дреди';

  @override
  String get avatarHelmet => 'Шолом';

  @override
  String get avatarKid => 'Малий';
}
