// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Panjabi Punjabi (`pa`).
class L10nPa extends L10n {
  L10nPa([String locale = 'pa']) : super(locale);

  @override
  String get tapToRide => 'ਟੈਪ ਕਰੋ ਤੇ ਚਲਾਓ';

  @override
  String dailyTrick(String trick) {
    return 'ਅੱਜ ਦੀ ਟ੍ਰਿਕ: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'ਸ਼ੈਲੀ: $style';
  }

  @override
  String get styleNeon => 'ਨਿਓਨ';

  @override
  String get styleComic => 'ਕਾਮਿਕ';

  @override
  String get stylePixel => 'ਪਿਕਸਲ';

  @override
  String goCountdown(int seconds) {
    return 'ਚੱਲੋ!  $seconds';
  }

  @override
  String get wrongTrick => 'ਗਲਤ ਟ੍ਰਿਕ';

  @override
  String get tooEarly => 'ਬਹੁਤ ਜਲਦੀ';

  @override
  String get waitForCircle => 'ਘੇਰੇ ਦੀ ਉਡੀਕ ਕਰੋ';

  @override
  String get noTrick => 'ਕੋਈ ਟ੍ਰਿਕ ਨਹੀਂ';

  @override
  String get losingSpeed => 'ਰਫ਼ਤਾਰ ਘੱਟ ਰਹੀ ਹੈ';

  @override
  String get bailTiming => 'ਗਲਤ ਟਾਈਮਿੰਗ';

  @override
  String get bailUnknown => 'ਅਣਜਾਣ ਟ੍ਰਿਕ';

  @override
  String get bailTooLong => 'ਟ੍ਰਿਕ ਹਵਾ ਵਿੱਚ ਪੂਰੀ ਨਹੀਂ ਹੋਈ';

  @override
  String get outOfSpeed => 'ਰਫ਼ਤਾਰ ਖਤਮ';

  @override
  String get rideOver => 'ਰਾਈਡ ਖਤਮ';

  @override
  String get bestTrick => 'ਸਭ ਤੋਂ ਵਧੀਆ ਟ੍ਰਿਕ';

  @override
  String get longestCombo => 'ਸਭ ਤੋਂ ਲੰਮਾ ਕੰਬੋ';

  @override
  String get tricksLanded => 'ਟ੍ਰਿਕਾਂ';

  @override
  String get avgTiming => 'ਔਸਤ ਟਾਈਮਿੰਗ';

  @override
  String get tapToContinue => 'ਜਾਰੀ ਰੱਖਣ ਲਈ ਟੈਪ ਕਰੋ';

  @override
  String get tabGrabs => 'ਗ੍ਰੈਬ';

  @override
  String get tabFlips => 'ਫਲਿੱਪ';

  @override
  String get tabSpins => 'ਸਪਿਨ';

  @override
  String get tabCombos => 'ਕੰਬੋ';

  @override
  String get trickBookHelp =>
      'ਕਿਨਾਰੇ ਦੇ ਨਾਲ = ਸਪਿਨ (ਘੜੀ ਦੀ ਦਿਸ਼ਾ ਵਿੱਚ FS, ਉਲਟ BS) · ਵਿਚਕਾਰੋਂ = ਗ੍ਰੈਬ · ਸਮਚਤੁਰਭੁਜ = ਫਲਿੱਪ। ਟ੍ਰਿਕਾਂ ਨੂੰ ਇੱਕੋ ਲਕੀਰ ਵਿੱਚ ਜੋੜੋ – ਅਗਲੀ ਉੱਥੋਂ ਸ਼ੁਰੂ ਹੁੰਦੀ ਹੈ ਜਿੱਥੇ ਪਿਛਲੀ ਖਤਮ ਹੋਈ। ਜਦੋਂ ਘੇਰਾ ਕਿਨਾਰੇ ’ਤੇ ਪਹੁੰਚੇ ਤਾਂ ਉਂਗਲ ਚੁੱਕੋ।';

  @override
  String get spinNote => 'ਕਿਨਾਰੇ ’ਤੇ ਕਿਤੋਂ ਵੀ ਸ਼ੁਰੂ ਕਰੋ';

  @override
  String pointsShort(int points) {
    return '$points ਅੰਕ';
  }

  @override
  String get tuningTitle => 'ਟਿਊਨਿੰਗ (M0)';

  @override
  String get tuningWindow => 'ਟਾਈਮਿੰਗ ਵਿੰਡੋ ਦੀ ਚੌੜਾਈ';

  @override
  String get tuningLatency => 'ਛੋਹ ਦੇਰੀ';

  @override
  String get tuningStartSpeed => 'ਸ਼ੁਰੂਆਤੀ ਰਫ਼ਤਾਰ';

  @override
  String get tuningCueLead => 'ਘੇਰੇ ਦੀ ਅਗਾਊਂ';

  @override
  String get tuningDeltaHelp => 'Δ ਉੱਪਰ ਸੱਜੇ ਕੋਨੇ ਵਿੱਚ = ਆਖਰੀ ਵਾਰ ਉਂਗਲ ਛੱਡਣ ਦਾ ਕਿਨਾਰੇ ਤੋਂ ਫ਼ਰਕ (− ਜਲਦੀ, + ਦੇਰ ਨਾਲ)।';

  @override
  String get avatarBeanie => 'ਊਨੀ ਟੋਪੀ';

  @override
  String get avatarDreads => 'ਡ੍ਰੈਡਸ';

  @override
  String get avatarHelmet => 'ਹੈਲਮੇਟ';

  @override
  String get avatarKid => 'ਛੋਟੂ';
}
