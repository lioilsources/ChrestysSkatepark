// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class L10nGu extends L10n {
  L10nGu([String locale = 'gu']) : super(locale);

  @override
  String get tapToRide => 'ટૅપ કરો અને ચલાવો';

  @override
  String dailyTrick(String trick) {
    return 'આજની ટ્રિક: $trick ×2';
  }

  @override
  String get proButton => 'PRO ×1.5';

  @override
  String styleButton(String style) {
    return 'શૈલી: $style';
  }

  @override
  String get styleNeon => 'નિયોન';

  @override
  String get styleComic => 'કૉમિક';

  @override
  String get stylePixel => 'પિક્સેલ';

  @override
  String goCountdown(int seconds) {
    return 'ચાલો!  $seconds';
  }

  @override
  String get wrongTrick => 'ખોટી ટ્રિક';

  @override
  String get tooEarly => 'બહુ વહેલું';

  @override
  String get waitForCircle => 'વર્તુળની રાહ જુઓ';

  @override
  String get noTrick => 'કોઈ ટ્રિક નથી';

  @override
  String get losingSpeed => 'ઝડપ ઘટી રહી છે';

  @override
  String get bailTiming => 'ખોટું ટાઇમિંગ';

  @override
  String get bailUnknown => 'અજાણી ટ્રિક';

  @override
  String get bailTooLong => 'ટ્રિક હવામાં પૂરી ન થઈ';

  @override
  String get outOfSpeed => 'ઝડપ પૂરી';

  @override
  String get rideOver => 'રાઇડ પૂરી';

  @override
  String get bestTrick => 'શ્રેષ્ઠ ટ્રિક';

  @override
  String get longestCombo => 'સૌથી લાંબો કૉમ્બો';

  @override
  String get tricksLanded => 'ટ્રિક્સ';

  @override
  String get avgTiming => 'સરેરાશ ટાઇમિંગ';

  @override
  String get tapToContinue => 'ચાલુ રાખવા ટૅપ કરો';

  @override
  String get tabGrabs => 'ગ્રેબ';

  @override
  String get tabFlips => 'ફ્લિપ';

  @override
  String get tabSpins => 'સ્પિન';

  @override
  String get tabCombos => 'કૉમ્બો';

  @override
  String get trickBookHelp =>
      'કિનારી સાથે = સ્પિન (ઘડિયાળની દિશામાં FS, ઊલટી BS) · વચ્ચેથી = ગ્રેબ · સમચતુર્ભુજ = ફ્લિપ. ટ્રિક્સને એક જ લીટીમાં જોડો – આગળની ટ્રિક પાછલી જ્યાં પૂરી થઈ ત્યાંથી શરૂ થાય છે. વર્તુળ કિનારે પહોંચે ત્યારે આંગળી ઉઠાવો.';

  @override
  String get spinNote => 'કિનારી પર ગમે ત્યાંથી શરૂ કરો';

  @override
  String pointsShort(int points) {
    return '$points પોઇન્ટ';
  }

  @override
  String get tuningTitle => 'ટ્યુનિંગ (M0)';

  @override
  String get tuningWindow => 'ટાઇમિંગ વિન્ડોની પહોળાઈ';

  @override
  String get tuningLatency => 'સ્પર્શ વિલંબ';

  @override
  String get tuningStartSpeed => 'શરૂઆતની ઝડપ';

  @override
  String get tuningCueLead => 'વર્તુળની આગોતરી';

  @override
  String get tuningDeltaHelp => 'Δ ઉપર જમણા ખૂણે = છેલ્લી વાર આંગળી છોડવાનો કિનારીથી તફાવત (− વહેલું, + મોડું).';

  @override
  String get avatarBeanie => 'ઊનની ટોપી';

  @override
  String get avatarDreads => 'ડ્રેડ્સ';

  @override
  String get avatarHelmet => 'હેલ્મેટ';

  @override
  String get avatarKid => 'છોટુ';
}
