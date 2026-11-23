// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class L10nHe extends L10n {
  L10nHe([String locale = 'he']) : super(locale);

  @override
  String get tapToRide => 'הקש וסע';

  @override
  String dailyTrick(String trick) {
    return 'טריק היום: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'סגנון: $style';
  }

  @override
  String get styleNeon => 'ניאון';

  @override
  String get styleComic => 'קומיקס';

  @override
  String get stylePixel => 'פיקסל';

  @override
  String goCountdown(int seconds) {
    return 'סע!  $seconds';
  }

  @override
  String get wrongTrick => 'טריק שגוי';

  @override
  String get tooEarly => 'מוקדם מדי';

  @override
  String get waitForCircle => 'חכה לעיגול';

  @override
  String get noTrick => 'בלי טריק';

  @override
  String get losingSpeed => 'אתה מאבד מהירות';

  @override
  String get bailTiming => 'תזמון גרוע';

  @override
  String get bailUnknown => 'טריק לא מוכר';

  @override
  String get bailTooLong => 'הטריק לא נכנס באוויר';

  @override
  String get outOfSpeed => 'נגמרה המהירות';

  @override
  String get rideOver => 'סוף הרכיבה';

  @override
  String get bestTrick => 'הטריק הטוב ביותר';

  @override
  String get longestCombo => 'הקומבו הארוך ביותר';

  @override
  String get tricksLanded => 'טריקים';

  @override
  String get avgTiming => 'תזמון ממוצע';

  @override
  String get tapToContinue => 'הקש כדי להמשיך';

  @override
  String get tabGrabs => 'גראבים';

  @override
  String get tabFlips => 'פליפים';

  @override
  String get tabSpins => 'ספינים';

  @override
  String get tabCombos => 'קומבו';

  @override
  String get trickBookHelp =>
      'לאורך השוליים = ספין (עם כיוון השעון FS, נגדו BS) · דרך המרכז = גראב · מעוין = פליפ. חבר טריקים בתנועה אחת – הבא מתחיל איפה שהקודם נגמר. הרם את האצבע כשהעיגול נוחת על הקצה.';

  @override
  String get spinNote => 'התחל בכל מקום על השוליים';

  @override
  String pointsShort(int points) {
    return '$points נק׳';
  }

  @override
  String get tuningTitle => 'כוונון (M0)';

  @override
  String get tuningWindow => 'רוחב חלון התזמון';

  @override
  String get tuningLatency => 'השהיית מגע';

  @override
  String get tuningStartSpeed => 'מהירות התחלה';

  @override
  String get tuningCueLead => 'הקדמת העיגול';

  @override
  String get tuningDeltaHelp => 'Δ בפינה הימנית העליונה = סטיית השחרור האחרון מהקצה (− מוקדם, + מאוחר).';

  @override
  String get avatarBeanie => 'כובע גרב';

  @override
  String get avatarDreads => 'ראסטות';

  @override
  String get avatarHelmet => 'קסדה';

  @override
  String get avatarKid => 'קטנצ׳יק';
}
