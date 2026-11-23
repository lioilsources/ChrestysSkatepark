// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Oriya (`or`).
class L10nOr extends L10n {
  L10nOr([String locale = 'or']) : super(locale);

  @override
  String get tapToRide => 'ଟ୍ୟାପ କରି ଚଲାନ୍ତୁ';

  @override
  String dailyTrick(String trick) {
    return 'ଆଜିର ଟ୍ରିକ୍: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'ଶୈଳୀ: $style';
  }

  @override
  String get styleNeon => 'ନିୟନ୍';

  @override
  String get styleComic => 'କମିକ୍';

  @override
  String get stylePixel => 'ପିକ୍ସେଲ୍';

  @override
  String goCountdown(int seconds) {
    return 'ଚାଲ!  $seconds';
  }

  @override
  String get wrongTrick => 'ଭୁଲ ଟ୍ରିକ୍';

  @override
  String get tooEarly => 'ବହୁତ ଶୀଘ୍ର';

  @override
  String get waitForCircle => 'ବୃତ୍ତ ପାଇଁ ଅପେକ୍ଷା କରନ୍ତୁ';

  @override
  String get noTrick => 'କୌଣସି ଟ୍ରିକ୍ ନାହିଁ';

  @override
  String get losingSpeed => 'ବେଗ କମୁଛି';

  @override
  String get bailTiming => 'ଭୁଲ ଟାଇମିଂ';

  @override
  String get bailUnknown => 'ଅଜଣା ଟ୍ରିକ୍';

  @override
  String get bailTooLong => 'ଟ୍ରିକ୍ ଆକାଶରେ ପୂରା ହେଲା ନାହିଁ';

  @override
  String get outOfSpeed => 'ବେଗ ସରିଗଲା';

  @override
  String get rideOver => 'ରାଇଡ୍ ଶେଷ';

  @override
  String get bestTrick => 'ସର୍ବୋତ୍ତମ ଟ୍ରିକ୍';

  @override
  String get longestCombo => 'ସବୁଠୁ ଲମ୍ବା କମ୍ବୋ';

  @override
  String get tricksLanded => 'ଟ୍ରିକ୍';

  @override
  String get avgTiming => 'ହାରାହାରି ଟାଇମିଂ';

  @override
  String get tapToContinue => 'ଜାରି ରଖିବାକୁ ଟ୍ୟାପ କରନ୍ତୁ';

  @override
  String get tabGrabs => 'ଗ୍ରାବ୍';

  @override
  String get tabFlips => 'ଫ୍ଲିପ୍';

  @override
  String get tabSpins => 'ସ୍ପିନ୍';

  @override
  String get tabCombos => 'କମ୍ବୋ';

  @override
  String get trickBookHelp =>
      'ଧାର ସହିତ = ସ୍ପିନ୍ (ଘଣ୍ଟା ଦିଗରେ FS, ବିପରୀତ BS) · ମଝିରେ = ଗ୍ରାବ୍ · ରମ୍ବସ୍ = ଫ୍ଲିପ୍। ଟ୍ରିକ୍ଗୁଡ଼ିକୁ ଗୋଟିଏ ଟାଣରେ ଯୋଡ଼ନ୍ତୁ – ପରବର୍ତ୍ତୀଟି ସେଠାରୁ ଆରମ୍ଭ ହୁଏ ଯେଉଁଠି ପୂର୍ବଟି ଶେଷ ହେଲା। ବୃତ୍ତ ଧାରରେ ପହଞ୍ଚିଲେ ଆଙ୍ଗୁଠି ଉଠାନ୍ତୁ।';

  @override
  String get spinNote => 'ଧାରର ଯେକୌଣସି ସ୍ଥାନରୁ ଆରମ୍ଭ କରନ୍ତୁ';

  @override
  String pointsShort(int points) {
    return '$points ପଏଣ୍ଟ';
  }

  @override
  String get tuningTitle => 'ଟ୍ୟୁନିଂ (M0)';

  @override
  String get tuningWindow => 'ଟାଇମିଂ ୱିଣ୍ଡୋ ଓସାର';

  @override
  String get tuningLatency => 'ସ୍ପର୍ଶ ବିଳମ୍ବ';

  @override
  String get tuningStartSpeed => 'ଆରମ୍ଭ ବେଗ';

  @override
  String get tuningCueLead => 'ବୃତ୍ତର ଅଗ୍ରିମ ସମୟ';

  @override
  String get tuningDeltaHelp => 'Δ ଉପର ଡାହାଣ କୋଣରେ = ଶେଷ ଥର ଆଙ୍ଗୁଠି ଛାଡ଼ିବାର ଧାରଠାରୁ ବିଚ୍ୟୁତି (− ଶୀଘ୍ର, + ବିଳମ୍ବ)।';

  @override
  String get avatarBeanie => 'ଉଲ୍ ଟୋପି';

  @override
  String get avatarDreads => 'ଡ୍ରେଡ୍ସ';

  @override
  String get avatarHelmet => 'ହେଲମେଟ୍';

  @override
  String get avatarKid => 'ଛୋଟୁ';
}
