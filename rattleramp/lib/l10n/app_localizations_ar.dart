// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class L10nAr extends L10n {
  L10nAr([String locale = 'ar']) : super(locale);

  @override
  String get tapToRide => 'انقر وانطلق';

  @override
  String dailyTrick(String trick) {
    return 'حركة اليوم: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'النمط: $style';
  }

  @override
  String get styleNeon => 'نيون';

  @override
  String get styleComic => 'كوميك';

  @override
  String get stylePixel => 'بكسل';

  @override
  String goCountdown(int seconds) {
    return 'انطلق!  $seconds';
  }

  @override
  String get wrongTrick => 'حركة خاطئة';

  @override
  String get tooEarly => 'مبكر جدًا';

  @override
  String get waitForCircle => 'انتظر الدائرة';

  @override
  String get noTrick => 'بلا حركة';

  @override
  String get losingSpeed => 'سرعتك تقل';

  @override
  String get bailTiming => 'توقيت سيئ';

  @override
  String get bailUnknown => 'حركة غير معروفة';

  @override
  String get bailTooLong => 'لم تتسع الحركة في الهواء';

  @override
  String get outOfSpeed => 'نفدت السرعة';

  @override
  String get rideOver => 'انتهت الجولة';

  @override
  String get bestTrick => 'أفضل حركة';

  @override
  String get longestCombo => 'أطول كومبو';

  @override
  String get tricksLanded => 'الحركات';

  @override
  String get avgTiming => 'متوسط التوقيت';

  @override
  String get tapToContinue => 'انقر للمتابعة';

  @override
  String get tabGrabs => 'الإمساك';

  @override
  String get tabFlips => 'القلب';

  @override
  String get tabSpins => 'الدوران';

  @override
  String get tabCombos => 'الكومبو';

  @override
  String get trickBookHelp =>
      'على الحافة = دوران (مع عقارب الساعة FS، عكسها BS) · عبر المركز = إمساك · المعين = قلب. اربط الحركات بخط واحد – تبدأ الحركة التالية حيث انتهت السابقة. ارفع إصبعك عندما تلامس الدائرة الحافة.';

  @override
  String get spinNote => 'ابدأ من أي مكان على الحافة';

  @override
  String pointsShort(int points) {
    return '$points نقطة';
  }

  @override
  String get tuningTitle => 'الضبط (M0)';

  @override
  String get tuningWindow => 'عرض نافذة التوقيت';

  @override
  String get tuningLatency => 'تأخر اللمس';

  @override
  String get tuningStartSpeed => 'سرعة البداية';

  @override
  String get tuningCueLead => 'أسبقية الدائرة';

  @override
  String get tuningDeltaHelp => 'Δ في الزاوية العلوية اليمنى = انحراف آخر إفلات عن الحافة (− مبكر، + متأخر).';

  @override
  String get avatarBeanie => 'قبعة صوف';

  @override
  String get avatarDreads => 'ضفائر';

  @override
  String get avatarHelmet => 'خوذة';

  @override
  String get avatarKid => 'الصغير';
}
