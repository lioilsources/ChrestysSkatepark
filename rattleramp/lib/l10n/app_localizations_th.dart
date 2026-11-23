// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class L10nTh extends L10n {
  L10nTh([String locale = 'th']) : super(locale);

  @override
  String get tapToRide => 'แตะเพื่อเริ่มไถ';

  @override
  String dailyTrick(String trick) {
    return 'ท่าประจำวัน: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'สไตล์: $style';
  }

  @override
  String get styleNeon => 'นีออน';

  @override
  String get styleComic => 'การ์ตูน';

  @override
  String get stylePixel => 'พิกเซล';

  @override
  String goCountdown(int seconds) {
    return 'ไป!  $seconds';
  }

  @override
  String get wrongTrick => 'ท่าผิด';

  @override
  String get tooEarly => 'เร็วเกินไป';

  @override
  String get waitForCircle => 'รอวงกลมก่อน';

  @override
  String get noTrick => 'ไม่มีท่า';

  @override
  String get losingSpeed => 'ความเร็วกำลังลดลง';

  @override
  String get bailTiming => 'จังหวะพลาด';

  @override
  String get bailUnknown => 'ท่าที่ไม่รู้จัก';

  @override
  String get bailTooLong => 'ทำท่าไม่ทันกลางอากาศ';

  @override
  String get outOfSpeed => 'หมดความเร็ว';

  @override
  String get rideOver => 'จบรอบ';

  @override
  String get bestTrick => 'ท่าที่ดีที่สุด';

  @override
  String get longestCombo => 'คอมโบยาวที่สุด';

  @override
  String get tricksLanded => 'จำนวนท่า';

  @override
  String get avgTiming => 'จังหวะเฉลี่ย';

  @override
  String get tapToContinue => 'แตะเพื่อไปต่อ';

  @override
  String get tabGrabs => 'แกร็บ';

  @override
  String get tabFlips => 'ฟลิป';

  @override
  String get tabSpins => 'สปิน';

  @override
  String get tabCombos => 'คอมโบ';

  @override
  String get trickBookHelp =>
      'ลากตามขอบ = สปิน (ตามเข็มนาฬิกา FS ทวนเข็ม BS) · ผ่านตรงกลาง = แกร็บ · รูปข้าวหลามตัด = ฟลิป ต่อท่าในการลากครั้งเดียว ท่าถัดไปเริ่มตรงที่ท่าก่อนหน้าจบ ยกนิ้วขึ้นเมื่อวงกลมแตะขอบ';

  @override
  String get spinNote => 'เริ่มตรงไหนของขอบก็ได้';

  @override
  String pointsShort(int points) {
    return '$points แต้ม';
  }

  @override
  String get tuningTitle => 'ปรับแต่ง (M0)';

  @override
  String get tuningWindow => 'ความกว้างช่วงจังหวะ';

  @override
  String get tuningLatency => 'ความหน่วงการแตะ';

  @override
  String get tuningStartSpeed => 'ความเร็วเริ่มต้น';

  @override
  String get tuningCueLead => 'เวลานำของวงกลม';

  @override
  String get tuningDeltaHelp => 'Δ มุมขวาบนระหว่างเล่น = ความคลาดของการปล่อยนิ้วครั้งล่าสุดจากขอบ (− เร็ว, + ช้า)';

  @override
  String get avatarBeanie => 'หมวกไหมพรม';

  @override
  String get avatarDreads => 'เดรดล็อก';

  @override
  String get avatarHelmet => 'หมวกกันน็อก';

  @override
  String get avatarKid => 'เจ้าตัวเล็ก';
}
