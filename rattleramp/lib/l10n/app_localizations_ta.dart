// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class L10nTa extends L10n {
  L10nTa([String locale = 'ta']) : super(locale);

  @override
  String get tapToRide => 'தட்டி ஓட்டு';

  @override
  String dailyTrick(String trick) {
    return 'இன்றைய ட்ரிக்: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'பாணி: $style';
  }

  @override
  String get styleNeon => 'நியான்';

  @override
  String get styleComic => 'காமிக்';

  @override
  String get stylePixel => 'பிக்சல்';

  @override
  String goCountdown(int seconds) {
    return 'போ!  $seconds';
  }

  @override
  String get wrongTrick => 'தவறான ட்ரிக்';

  @override
  String get tooEarly => 'மிக சீக்கிரம்';

  @override
  String get waitForCircle => 'வட்டத்திற்காக காத்திருங்கள்';

  @override
  String get noTrick => 'ட்ரிக் இல்லை';

  @override
  String get losingSpeed => 'வேகம் குறைகிறது';

  @override
  String get bailTiming => 'தவறான டைமிங்';

  @override
  String get bailUnknown => 'தெரியாத ட்ரிக்';

  @override
  String get bailTooLong => 'ட்ரிக் காற்றில் முடியவில்லை';

  @override
  String get outOfSpeed => 'வேகம் தீர்ந்தது';

  @override
  String get rideOver => 'ரைடு முடிந்தது';

  @override
  String get bestTrick => 'சிறந்த ட்ரிக்';

  @override
  String get longestCombo => 'நீளமான காம்போ';

  @override
  String get tricksLanded => 'ட்ரிக்குகள்';

  @override
  String get avgTiming => 'சராசரி டைமிங்';

  @override
  String get tapToContinue => 'தொடர தட்டவும்';

  @override
  String get tabGrabs => 'கிராப்';

  @override
  String get tabFlips => 'ஃபிளிப்';

  @override
  String get tabSpins => 'ஸ்பின்';

  @override
  String get tabCombos => 'காம்போ';

  @override
  String get trickBookHelp =>
      'விளிம்பைச் சுற்றி = ஸ்பின் (கடிகாரச் சுற்றில் FS, எதிர்ச் சுற்றில் BS) · நடுவழியாக = கிராப் · சாய்சதுரம் = ஃபிளிப். ட்ரிக்குகளை ஒரே இழுப்பில் இணைக்கவும் – அடுத்தது முந்தையது முடிந்த இடத்தில் தொடங்கும். வட்டம் விளிம்பைத் தொடும்போது விரலை எடுக்கவும்.';

  @override
  String get spinNote => 'விளிம்பில் எங்கிருந்தும் தொடங்கலாம்';

  @override
  String pointsShort(int points) {
    return '$points புள்ளிகள்';
  }

  @override
  String get tuningTitle => 'டியூனிங் (M0)';

  @override
  String get tuningWindow => 'டைமிங் சாளர அகலம்';

  @override
  String get tuningLatency => 'தொடு தாமதம்';

  @override
  String get tuningStartSpeed => 'தொடக்க வேகம்';

  @override
  String get tuningCueLead => 'வட்டத்தின் முன்னோட்டம்';

  @override
  String get tuningDeltaHelp =>
      'Δ மேல் வலது மூலையில் = கடைசியாக விரலை எடுத்ததற்கும் விளிம்புக்குமான வேறுபாடு (− முன்னதாக, + தாமதமாக).';

  @override
  String get avatarBeanie => 'கம்பளி தொப்பி';

  @override
  String get avatarDreads => 'ட்ரெட்ஸ்';

  @override
  String get avatarHelmet => 'ஹெல்மெட்';

  @override
  String get avatarKid => 'குட்டி';
}
