// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class L10nTe extends L10n {
  L10nTe([String locale = 'te']) : super(locale);

  @override
  String get tapToRide => 'ట్యాప్ చేసి నడపండి';

  @override
  String dailyTrick(String trick) {
    return 'నేటి ట్రిక్: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'శైలి: $style';
  }

  @override
  String get styleNeon => 'నియాన్';

  @override
  String get styleComic => 'కామిక్';

  @override
  String get stylePixel => 'పిక్సెల్';

  @override
  String goCountdown(int seconds) {
    return 'పదండి!  $seconds';
  }

  @override
  String get wrongTrick => 'తప్పు ట్రిక్';

  @override
  String get tooEarly => 'చాలా ముందుగా';

  @override
  String get waitForCircle => 'వృత్తం కోసం వేచి ఉండండి';

  @override
  String get noTrick => 'ట్రిక్ లేదు';

  @override
  String get losingSpeed => 'వేగం తగ్గుతోంది';

  @override
  String get bailTiming => 'తప్పు టైమింగ్';

  @override
  String get bailUnknown => 'తెలియని ట్రిక్';

  @override
  String get bailTooLong => 'ట్రిక్ గాల్లో పూర్తి కాలేదు';

  @override
  String get outOfSpeed => 'వేగం అయిపోయింది';

  @override
  String get rideOver => 'రైడ్ ముగిసింది';

  @override
  String get bestTrick => 'ఉత్తమ ట్రిక్';

  @override
  String get longestCombo => 'పొడవైన కాంబో';

  @override
  String get tricksLanded => 'ట్రిక్‌లు';

  @override
  String get avgTiming => 'సగటు టైమింగ్';

  @override
  String get tapToContinue => 'కొనసాగించడానికి ట్యాప్ చేయండి';

  @override
  String get tabGrabs => 'గ్రాబ్';

  @override
  String get tabFlips => 'ఫ్లిప్';

  @override
  String get tabSpins => 'స్పిన్';

  @override
  String get tabCombos => 'కాంబో';

  @override
  String get trickBookHelp =>
      'అంచు వెంట = స్పిన్ (సవ్యదిశలో FS, అపసవ్యదిశలో BS) · మధ్య గుండా = గ్రాబ్ · సమచతుర్భుజం = ఫ్లిప్. ట్రిక్‌లను ఒకే గీతలో కలపండి – తదుపరిది మునుపటిది ముగిసిన చోట మొదలవుతుంది. వృత్తం అంచును తాకినప్పుడు వేలు ఎత్తండి.';

  @override
  String get spinNote => 'అంచుపై ఎక్కడి నుండైనా మొదలుపెట్టండి';

  @override
  String pointsShort(int points) {
    return '$points పాయింట్లు';
  }

  @override
  String get tuningTitle => 'ట్యూనింగ్ (M0)';

  @override
  String get tuningWindow => 'టైమింగ్ విండో వెడల్పు';

  @override
  String get tuningLatency => 'టచ్ ఆలస్యం';

  @override
  String get tuningStartSpeed => 'ప్రారంభ వేగం';

  @override
  String get tuningCueLead => 'వృత్తం ముందస్తు సమయం';

  @override
  String get tuningDeltaHelp => 'Δ పై కుడి మూలలో = చివరిసారి వేలు వదిలిన సమయం అంచు నుండి తేడా (− ముందుగా, + ఆలస్యంగా).';

  @override
  String get avatarBeanie => 'ఉన్ని టోపీ';

  @override
  String get avatarDreads => 'డ్రెడ్స్';

  @override
  String get avatarHelmet => 'హెల్మెట్';

  @override
  String get avatarKid => 'చిన్నోడు';
}
