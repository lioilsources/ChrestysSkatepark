// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class L10nMl extends L10n {
  L10nMl([String locale = 'ml']) : super(locale);

  @override
  String get tapToRide => 'ടാപ്പ് ചെയ്ത് ഓടിക്കൂ';

  @override
  String dailyTrick(String trick) {
    return 'ഇന്നത്തെ ട്രിക്ക്: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'ശൈലി: $style';
  }

  @override
  String get styleNeon => 'നിയോൺ';

  @override
  String get styleComic => 'കോമിക്';

  @override
  String get stylePixel => 'പിക്സൽ';

  @override
  String goCountdown(int seconds) {
    return 'പോകൂ!  $seconds';
  }

  @override
  String get wrongTrick => 'തെറ്റായ ട്രിക്ക്';

  @override
  String get tooEarly => 'വളരെ നേരത്തെ';

  @override
  String get waitForCircle => 'വൃത്തത്തിനായി കാത്തിരിക്കൂ';

  @override
  String get noTrick => 'ട്രിക്ക് ഇല്ല';

  @override
  String get losingSpeed => 'വേഗം കുറയുന്നു';

  @override
  String get bailTiming => 'തെറ്റായ ടൈമിംഗ്';

  @override
  String get bailUnknown => 'അറിയാത്ത ട്രിക്ക്';

  @override
  String get bailTooLong => 'ട്രിക്ക് വായുവിൽ പൂർത്തിയായില്ല';

  @override
  String get outOfSpeed => 'വേഗം തീർന്നു';

  @override
  String get rideOver => 'റൈഡ് കഴിഞ്ഞു';

  @override
  String get bestTrick => 'മികച്ച ട്രിക്ക്';

  @override
  String get longestCombo => 'ഏറ്റവും നീണ്ട കോംബോ';

  @override
  String get tricksLanded => 'ട്രിക്കുകൾ';

  @override
  String get avgTiming => 'ശരാശരി ടൈമിംഗ്';

  @override
  String get tapToContinue => 'തുടരാൻ ടാപ്പ് ചെയ്യൂ';

  @override
  String get tabGrabs => 'ഗ്രാബ്';

  @override
  String get tabFlips => 'ഫ്ലിപ്പ്';

  @override
  String get tabSpins => 'സ്പിൻ';

  @override
  String get tabCombos => 'കോംബോ';

  @override
  String get trickBookHelp =>
      'അരികിലൂടെ = സ്പിൻ (ഘടികാരദിശയിൽ FS, എതിർദിശയിൽ BS) · നടുവിലൂടെ = ഗ്രാബ് · സമചതുർഭുജം = ഫ്ലിപ്പ്. ട്രിക്കുകൾ ഒറ്റ വരയിൽ ചേർക്കൂ – അടുത്തത് മുമ്പത്തേത് അവസാനിച്ചിടത്ത് തുടങ്ങും. വൃത്തം അരികിൽ എത്തുമ്പോൾ വിരൽ ഉയർത്തൂ.';

  @override
  String get spinNote => 'അരികിൽ എവിടെ നിന്നും തുടങ്ങാം';

  @override
  String pointsShort(int points) {
    return '$points പോയിന്റ്';
  }

  @override
  String get tuningTitle => 'ട്യൂണിംഗ് (M0)';

  @override
  String get tuningWindow => 'ടൈമിംഗ് വിൻഡോ വീതി';

  @override
  String get tuningLatency => 'സ്പർശന കാലതാമസം';

  @override
  String get tuningStartSpeed => 'തുടക്ക വേഗം';

  @override
  String get tuningCueLead => 'വൃത്തത്തിന്റെ മുന്നറിയിപ്പ് സമയം';

  @override
  String get tuningDeltaHelp =>
      'Δ മുകളിൽ വലത് മൂലയിൽ = അവസാനമായി വിരൽ വിട്ടതും അരികും തമ്മിലുള്ള വ്യത്യാസം (− നേരത്തെ, + വൈകി).';

  @override
  String get avatarBeanie => 'കമ്പിളിത്തൊപ്പി';

  @override
  String get avatarDreads => 'ഡ്രെഡ്സ്';

  @override
  String get avatarHelmet => 'ഹെൽമെറ്റ്';

  @override
  String get avatarKid => 'കുട്ടൻ';
}
