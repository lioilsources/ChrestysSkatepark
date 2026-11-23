// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class L10nMr extends L10n {
  L10nMr([String locale = 'mr']) : super(locale);

  @override
  String get tapToRide => 'टॅप करा आणि चला';

  @override
  String dailyTrick(String trick) {
    return 'आजची ट्रिक: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'शैली: $style';
  }

  @override
  String get styleNeon => 'निऑन';

  @override
  String get styleComic => 'कॉमिक';

  @override
  String get stylePixel => 'पिक्सेल';

  @override
  String goCountdown(int seconds) {
    return 'चला!  $seconds';
  }

  @override
  String get wrongTrick => 'चुकीची ट्रिक';

  @override
  String get tooEarly => 'खूप लवकर';

  @override
  String get waitForCircle => 'वर्तुळाची वाट पाहा';

  @override
  String get noTrick => 'ट्रिक नाही';

  @override
  String get losingSpeed => 'वेग कमी होत आहे';

  @override
  String get bailTiming => 'चुकीचे टायमिंग';

  @override
  String get bailUnknown => 'अनोळखी ट्रिक';

  @override
  String get bailTooLong => 'ट्रिक हवेत पूर्ण झाली नाही';

  @override
  String get outOfSpeed => 'वेग संपला';

  @override
  String get rideOver => 'राइड संपली';

  @override
  String get bestTrick => 'सर्वोत्तम ट्रिक';

  @override
  String get longestCombo => 'सर्वात लांब कॉम्बो';

  @override
  String get tricksLanded => 'ट्रिक्स';

  @override
  String get avgTiming => 'सरासरी टायमिंग';

  @override
  String get tapToContinue => 'पुढे जाण्यासाठी टॅप करा';

  @override
  String get tabGrabs => 'ग्रॅब';

  @override
  String get tabFlips => 'फ्लिप';

  @override
  String get tabSpins => 'स्पिन';

  @override
  String get tabCombos => 'कॉम्बो';

  @override
  String get trickBookHelp =>
      'कडेने = स्पिन (घड्याळाच्या दिशेने FS, उलट BS) · मध्यातून = ग्रॅब · समभुज चौकोन = फ्लिप. ट्रिक्स एकाच रेषेत जोडा – पुढची ट्रिक मागची जिथे संपली तिथून सुरू होते. वर्तुळ कडेवर पोहोचताच बोट उचला.';

  @override
  String get spinNote => 'कडेवर कुठूनही सुरू करा';

  @override
  String pointsShort(int points) {
    return '$points गुण';
  }

  @override
  String get tuningTitle => 'ट्यूनिंग (M0)';

  @override
  String get tuningWindow => 'टायमिंग विंडोची रुंदी';

  @override
  String get tuningLatency => 'स्पर्श विलंब';

  @override
  String get tuningStartSpeed => 'सुरुवातीचा वेग';

  @override
  String get tuningCueLead => 'वर्तुळाची आघाडी';

  @override
  String get tuningDeltaHelp =>
      'Δ वरच्या उजव्या कोपऱ्यात = शेवटच्या वेळी बोट सोडण्याचा कडेपासूनचा फरक (− लवकर, + उशिरा).';

  @override
  String get avatarBeanie => 'लोकरी टोपी';

  @override
  String get avatarDreads => 'ड्रेड्स';

  @override
  String get avatarHelmet => 'हेल्मेट';

  @override
  String get avatarKid => 'छोटू';
}
