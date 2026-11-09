// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class L10nKn extends L10n {
  L10nKn([String locale = 'kn']) : super(locale);

  @override
  String get tapToRide => 'ಟ್ಯಾಪ್ ಮಾಡಿ ಓಡಿಸಿ';

  @override
  String dailyTrick(String trick) {
    return 'ಇಂದಿನ ಟ್ರಿಕ್: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'ಶೈಲಿ: $style';
  }

  @override
  String get styleNeon => 'ನಿಯಾನ್';

  @override
  String get styleComic => 'ಕಾಮಿಕ್';

  @override
  String get stylePixel => 'ಪಿಕ್ಸೆಲ್';

  @override
  String goCountdown(int seconds) {
    return 'ಹೊರಡಿ!  $seconds';
  }

  @override
  String get wrongTrick => 'ತಪ್ಪು ಟ್ರಿಕ್';

  @override
  String get tooEarly => 'ತುಂಬಾ ಬೇಗ';

  @override
  String get waitForCircle => 'ವೃತ್ತಕ್ಕಾಗಿ ಕಾಯಿರಿ';

  @override
  String get noTrick => 'ಟ್ರಿಕ್ ಇಲ್ಲ';

  @override
  String get losingSpeed => 'ವೇಗ ಕಡಿಮೆಯಾಗುತ್ತಿದೆ';

  @override
  String get bailTiming => 'ತಪ್ಪು ಟೈಮಿಂಗ್';

  @override
  String get bailUnknown => 'ಅಪರಿಚಿತ ಟ್ರಿಕ್';

  @override
  String get bailTooLong => 'ಟ್ರಿಕ್ ಗಾಳಿಯಲ್ಲಿ ಮುಗಿಯಲಿಲ್ಲ';

  @override
  String get outOfSpeed => 'ವೇಗ ಮುಗಿಯಿತು';

  @override
  String get rideOver => 'ರೈಡ್ ಮುಗಿಯಿತು';

  @override
  String get bestTrick => 'ಅತ್ಯುತ್ತಮ ಟ್ರಿಕ್';

  @override
  String get longestCombo => 'ಅತಿ ಉದ್ದದ ಕಾಂಬೊ';

  @override
  String get tricksLanded => 'ಟ್ರಿಕ್‌ಗಳು';

  @override
  String get avgTiming => 'ಸರಾಸರಿ ಟೈಮಿಂಗ್';

  @override
  String get tapToContinue => 'ಮುಂದುವರಿಸಲು ಟ್ಯಾಪ್ ಮಾಡಿ';

  @override
  String get tabGrabs => 'ಗ್ರ್ಯಾಬ್';

  @override
  String get tabFlips => 'ಫ್ಲಿಪ್';

  @override
  String get tabSpins => 'ಸ್ಪಿನ್';

  @override
  String get tabCombos => 'ಕಾಂಬೊ';

  @override
  String get trickBookHelp =>
      'ಅಂಚಿನುದ್ದಕ್ಕೂ = ಸ್ಪಿನ್ (ಪ್ರದಕ್ಷಿಣವಾಗಿ FS, ಅಪ್ರದಕ್ಷಿಣವಾಗಿ BS) · ಮಧ್ಯದ ಮೂಲಕ = ಗ್ರ್ಯಾಬ್ · ವಜ್ರಾಕೃತಿ = ಫ್ಲಿಪ್. ಟ್ರಿಕ್‌ಗಳನ್ನು ಒಂದೇ ಎಳೆತದಲ್ಲಿ ಜೋಡಿಸಿ – ಮುಂದಿನದು ಹಿಂದಿನದು ಮುಗಿದಲ್ಲಿಂದ ಶುರುವಾಗುತ್ತದೆ. ವೃತ್ತ ಅಂಚನ್ನು ತಲುಪಿದಾಗ ಬೆರಳು ಎತ್ತಿ.';

  @override
  String get spinNote => 'ಅಂಚಿನಲ್ಲಿ ಎಲ್ಲಿಂದಾದರೂ ಶುರು ಮಾಡಿ';

  @override
  String pointsShort(int points) {
    return '$points ಅಂಕಗಳು';
  }

  @override
  String get tuningTitle => 'ಟ್ಯೂನಿಂಗ್ (M0)';

  @override
  String get tuningWindow => 'ಟೈಮಿಂಗ್ ವಿಂಡೋ ಅಗಲ';

  @override
  String get tuningLatency => 'ಸ್ಪರ್ಶ ವಿಳಂಬ';

  @override
  String get tuningStartSpeed => 'ಆರಂಭಿಕ ವೇಗ';

  @override
  String get tuningCueLead => 'ವೃತ್ತದ ಮುನ್ನಡೆ';

  @override
  String get tuningDeltaHelp =>
      'Δ ಮೇಲಿನ ಬಲ ಮೂಲೆಯಲ್ಲಿ = ಕೊನೆಯ ಬಾರಿ ಬೆರಳು ಬಿಟ್ಟದ್ದು ಅಂಚಿನಿಂದ ಎಷ್ಟು ವ್ಯತ್ಯಾಸ (− ಬೇಗ, + ತಡ).';

  @override
  String get avatarBeanie => 'ಉಣ್ಣೆ ಟೋಪಿ';

  @override
  String get avatarDreads => 'ಡ್ರೆಡ್ಸ್';

  @override
  String get avatarHelmet => 'ಹೆಲ್ಮೆಟ್';

  @override
  String get avatarKid => 'ಪುಟ್ಟ';
}
