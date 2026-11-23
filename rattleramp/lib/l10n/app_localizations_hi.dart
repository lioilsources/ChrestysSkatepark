// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class L10nHi extends L10n {
  L10nHi([String locale = 'hi']) : super(locale);

  @override
  String get tapToRide => 'टैप करें और चलें';

  @override
  String dailyTrick(String trick) {
    return 'आज की ट्रिक: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'स्टाइल: $style';
  }

  @override
  String get styleNeon => 'नियॉन';

  @override
  String get styleComic => 'कॉमिक';

  @override
  String get stylePixel => 'पिक्सेल';

  @override
  String goCountdown(int seconds) {
    return 'चलो!  $seconds';
  }

  @override
  String get wrongTrick => 'गलत ट्रिक';

  @override
  String get tooEarly => 'बहुत जल्दी';

  @override
  String get waitForCircle => 'घेरे का इंतज़ार करें';

  @override
  String get noTrick => 'कोई ट्रिक नहीं';

  @override
  String get losingSpeed => 'रफ़्तार घट रही है';

  @override
  String get bailTiming => 'गलत टाइमिंग';

  @override
  String get bailUnknown => 'अनजानी ट्रिक';

  @override
  String get bailTooLong => 'ट्रिक हवा में पूरी नहीं हुई';

  @override
  String get outOfSpeed => 'रफ़्तार खत्म';

  @override
  String get rideOver => 'राइड खत्म';

  @override
  String get bestTrick => 'सबसे अच्छी ट्रिक';

  @override
  String get longestCombo => 'सबसे लंबा कॉम्बो';

  @override
  String get tricksLanded => 'ट्रिक्स';

  @override
  String get avgTiming => 'औसत टाइमिंग';

  @override
  String get tapToContinue => 'जारी रखने के लिए टैप करें';

  @override
  String get tabGrabs => 'ग्रैब';

  @override
  String get tabFlips => 'फ़्लिप';

  @override
  String get tabSpins => 'स्पिन';

  @override
  String get tabCombos => 'कॉम्बो';

  @override
  String get trickBookHelp =>
      'किनारे के साथ = स्पिन (घड़ी की दिशा में FS, उल्टी दिशा में BS) · बीच से = ग्रैब · समचतुर्भुज = फ़्लिप। ट्रिक्स को एक ही लकीर में जोड़ें – अगली वहीं से शुरू होती है जहाँ पिछली खत्म हुई। जब घेरा किनारे पर पहुँचे तो उंगली उठा लें।';

  @override
  String get spinNote => 'किनारे पर कहीं से भी शुरू करें';

  @override
  String pointsShort(int points) {
    return '$points अंक';
  }

  @override
  String get tuningTitle => 'ट्यूनिंग (M0)';

  @override
  String get tuningWindow => 'टाइमिंग विंडो की चौड़ाई';

  @override
  String get tuningLatency => 'टच विलंब';

  @override
  String get tuningStartSpeed => 'शुरुआती रफ़्तार';

  @override
  String get tuningCueLead => 'घेरे की बढ़त';

  @override
  String get tuningDeltaHelp => 'Δ ऊपर दाएँ कोने में = आखिरी बार उंगली छोड़ने का किनारे से अंतर (− जल्दी, + देर से)।';

  @override
  String get avatarBeanie => 'ऊनी टोपी';

  @override
  String get avatarDreads => 'ड्रेड्स';

  @override
  String get avatarHelmet => 'हेलमेट';

  @override
  String get avatarKid => 'छोटू';
}
