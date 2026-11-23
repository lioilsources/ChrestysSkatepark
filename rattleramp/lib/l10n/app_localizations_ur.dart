// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class L10nUr extends L10n {
  L10nUr([String locale = 'ur']) : super(locale);

  @override
  String get tapToRide => 'ٹیپ کریں اور چلیں';

  @override
  String dailyTrick(String trick) {
    return 'آج کا کرتب: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'انداز: $style';
  }

  @override
  String get styleNeon => 'نیون';

  @override
  String get styleComic => 'کامک';

  @override
  String get stylePixel => 'پکسل';

  @override
  String goCountdown(int seconds) {
    return 'چلو!  $seconds';
  }

  @override
  String get wrongTrick => 'غلط کرتب';

  @override
  String get tooEarly => 'بہت جلدی';

  @override
  String get waitForCircle => 'دائرے کا انتظار کریں';

  @override
  String get noTrick => 'کوئی کرتب نہیں';

  @override
  String get losingSpeed => 'رفتار کم ہو رہی ہے';

  @override
  String get bailTiming => 'غلط ٹائمنگ';

  @override
  String get bailUnknown => 'نامعلوم کرتب';

  @override
  String get bailTooLong => 'کرتب ہوا میں پورا نہیں ہوا';

  @override
  String get outOfSpeed => 'رفتار ختم';

  @override
  String get rideOver => 'سواری ختم';

  @override
  String get bestTrick => 'بہترین کرتب';

  @override
  String get longestCombo => 'سب سے لمبا کومبو';

  @override
  String get tricksLanded => 'کرتب';

  @override
  String get avgTiming => 'اوسط ٹائمنگ';

  @override
  String get tapToContinue => 'جاری رکھنے کے لیے ٹیپ کریں';

  @override
  String get tabGrabs => 'گریب';

  @override
  String get tabFlips => 'فلپ';

  @override
  String get tabSpins => 'اسپن';

  @override
  String get tabCombos => 'کومبو';

  @override
  String get trickBookHelp =>
      'کنارے کے ساتھ = اسپن (گھڑی کی سمت FS، الٹی سمت BS) · درمیان سے = گریب · معین = فلپ۔ کرتب ایک ہی لکیر میں جوڑیں – اگلا وہیں سے شروع ہوتا ہے جہاں پچھلا ختم ہوا۔ جب دائرہ کنارے پر پہنچے تو انگلی اٹھا لیں۔';

  @override
  String get spinNote => 'کنارے پر کہیں سے بھی شروع کریں';

  @override
  String pointsShort(int points) {
    return '$points پوائنٹس';
  }

  @override
  String get tuningTitle => 'ٹیوننگ (M0)';

  @override
  String get tuningWindow => 'ٹائمنگ ونڈو کی چوڑائی';

  @override
  String get tuningLatency => 'ٹچ میں تاخیر';

  @override
  String get tuningStartSpeed => 'ابتدائی رفتار';

  @override
  String get tuningCueLead => 'دائرے کی پیش رفت';

  @override
  String get tuningDeltaHelp => 'Δ اوپر دائیں کونے میں = آخری بار انگلی چھوڑنے کا کنارے سے فرق (− جلدی، + دیر)۔';

  @override
  String get avatarBeanie => 'اونی ٹوپی';

  @override
  String get avatarDreads => 'ڈریڈز';

  @override
  String get avatarHelmet => 'ہیلمٹ';

  @override
  String get avatarKid => 'چھوٹو';
}
