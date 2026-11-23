import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Attract screen call to action (tap anywhere to start).
  ///
  /// In cs, this message translates to:
  /// **'TAPNI A JEĎ'**
  String get tapToRide;

  /// Trick of the day banner; the trick scores double.
  ///
  /// In cs, this message translates to:
  /// **'TRIK DNE: {trick} ×2'**
  String dailyTrick(String trick);

  /// Button that starts a Pro ride (score ×1.5, no hints).
  ///
  /// In cs, this message translates to:
  /// **'PRO ×1,5'**
  String get proButton;

  /// Art style switch button.
  ///
  /// In cs, this message translates to:
  /// **'STYL: {style}'**
  String styleButton(String style);

  /// No description provided for @styleNeon.
  ///
  /// In cs, this message translates to:
  /// **'NEON'**
  String get styleNeon;

  /// No description provided for @styleComic.
  ///
  /// In cs, this message translates to:
  /// **'KOMIKS'**
  String get styleComic;

  /// No description provided for @stylePixel.
  ///
  /// In cs, this message translates to:
  /// **'PIXEL'**
  String get stylePixel;

  /// Avatar picker start button with countdown seconds.
  ///
  /// In cs, this message translates to:
  /// **'JEĎ!  {seconds}'**
  String goCountdown(int seconds);

  /// No description provided for @wrongTrick.
  ///
  /// In cs, this message translates to:
  /// **'ŠPATNÝ TRIK'**
  String get wrongTrick;

  /// No description provided for @tooEarly.
  ///
  /// In cs, this message translates to:
  /// **'MOC BRZY'**
  String get tooEarly;

  /// Released too early: wait for the timing circle to reach the coping.
  ///
  /// In cs, this message translates to:
  /// **'počkej na kruh'**
  String get waitForCircle;

  /// No description provided for @noTrick.
  ///
  /// In cs, this message translates to:
  /// **'BEZ TRIKU'**
  String get noTrick;

  /// No description provided for @losingSpeed.
  ///
  /// In cs, this message translates to:
  /// **'ztrácíš rychlost'**
  String get losingSpeed;

  /// No description provided for @bailTiming.
  ///
  /// In cs, this message translates to:
  /// **'špatné načasování'**
  String get bailTiming;

  /// No description provided for @bailUnknown.
  ///
  /// In cs, this message translates to:
  /// **'neznámý trik'**
  String get bailUnknown;

  /// Bail reason: the drawn trick was longer than the remaining airtime.
  ///
  /// In cs, this message translates to:
  /// **'trik se nevešel do airu'**
  String get bailTooLong;

  /// No description provided for @outOfSpeed.
  ///
  /// In cs, this message translates to:
  /// **'DOŠLA RYCHLOST'**
  String get outOfSpeed;

  /// No description provided for @rideOver.
  ///
  /// In cs, this message translates to:
  /// **'KONEC JÍZDY'**
  String get rideOver;

  /// No description provided for @bestTrick.
  ///
  /// In cs, this message translates to:
  /// **'NEJLEPŠÍ TRIK'**
  String get bestTrick;

  /// No description provided for @longestCombo.
  ///
  /// In cs, this message translates to:
  /// **'NEJDELŠÍ COMBO'**
  String get longestCombo;

  /// Stat card label: number of landed tricks.
  ///
  /// In cs, this message translates to:
  /// **'TRIKŮ'**
  String get tricksLanded;

  /// No description provided for @avgTiming.
  ///
  /// In cs, this message translates to:
  /// **'PRŮMĚRNÝ TIMING'**
  String get avgTiming;

  /// No description provided for @tapToContinue.
  ///
  /// In cs, this message translates to:
  /// **'TAPNI PRO POKRAČOVÁNÍ'**
  String get tapToContinue;

  /// No description provided for @tabGrabs.
  ///
  /// In cs, this message translates to:
  /// **'GRABY'**
  String get tabGrabs;

  /// No description provided for @tabFlips.
  ///
  /// In cs, this message translates to:
  /// **'FLIPY'**
  String get tabFlips;

  /// No description provided for @tabSpins.
  ///
  /// In cs, this message translates to:
  /// **'SPINY'**
  String get tabSpins;

  /// No description provided for @tabCombos.
  ///
  /// In cs, this message translates to:
  /// **'KOMBA'**
  String get tabCombos;

  /// Explains the 3x3 swipe grammar. FS/BS stay as-is.
  ///
  /// In cs, this message translates to:
  /// **'Po obvodu = spin (po směru hodin FS, proti BS) · přes střed = grab · kosočtverec = flip. Spoj triky jedním tahem – další začíná tam, kde předchozí skončil. Pusť prst, když kruh dosedne na hranu.'**
  String get trickBookHelp;

  /// No description provided for @spinNote.
  ///
  /// In cs, this message translates to:
  /// **'začni kdekoli na okraji'**
  String get spinNote;

  /// Points abbreviation on trick cards.
  ///
  /// In cs, this message translates to:
  /// **'{points} b'**
  String pointsShort(int points);

  /// Hidden staff tuning panel title.
  ///
  /// In cs, this message translates to:
  /// **'LADĚNÍ (M0)'**
  String get tuningTitle;

  /// No description provided for @tuningWindow.
  ///
  /// In cs, this message translates to:
  /// **'Šířka timing okna'**
  String get tuningWindow;

  /// No description provided for @tuningLatency.
  ///
  /// In cs, this message translates to:
  /// **'Latence dotyku'**
  String get tuningLatency;

  /// No description provided for @tuningStartSpeed.
  ///
  /// In cs, this message translates to:
  /// **'Startovní rychlost'**
  String get tuningStartSpeed;

  /// No description provided for @tuningCueLead.
  ///
  /// In cs, this message translates to:
  /// **'Předstih kruhu'**
  String get tuningCueLead;

  /// Explains the Δ ms readout in the ride's top-right corner.
  ///
  /// In cs, this message translates to:
  /// **'Δ v pravém horním rohu jízdy = odchylka posledního puštění od hrany (− brzy, + pozdě).'**
  String get tuningDeltaHelp;

  /// No description provided for @avatarBeanie.
  ///
  /// In cs, this message translates to:
  /// **'Kulich'**
  String get avatarBeanie;

  /// No description provided for @avatarDreads.
  ///
  /// In cs, this message translates to:
  /// **'Dready'**
  String get avatarDreads;

  /// No description provided for @avatarHelmet.
  ///
  /// In cs, this message translates to:
  /// **'Helma'**
  String get avatarHelmet;

  /// Avatar preset name: a small kid skater.
  ///
  /// In cs, this message translates to:
  /// **'Prcek'**
  String get avatarKid;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return L10nZhHans();
          case 'Hant':
            return L10nZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return L10nPtBr();
          case 'PT':
            return L10nPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return L10nAr();
    case 'bn':
      return L10nBn();
    case 'ca':
      return L10nCa();
    case 'cs':
      return L10nCs();
    case 'da':
      return L10nDa();
    case 'de':
      return L10nDe();
    case 'el':
      return L10nEl();
    case 'en':
      return L10nEn();
    case 'es':
      return L10nEs();
    case 'fi':
      return L10nFi();
    case 'fr':
      return L10nFr();
    case 'gu':
      return L10nGu();
    case 'he':
      return L10nHe();
    case 'hi':
      return L10nHi();
    case 'hr':
      return L10nHr();
    case 'hu':
      return L10nHu();
    case 'id':
      return L10nId();
    case 'it':
      return L10nIt();
    case 'ja':
      return L10nJa();
    case 'kn':
      return L10nKn();
    case 'ko':
      return L10nKo();
    case 'ml':
      return L10nMl();
    case 'mr':
      return L10nMr();
    case 'ms':
      return L10nMs();
    case 'nb':
      return L10nNb();
    case 'nl':
      return L10nNl();
    case 'or':
      return L10nOr();
    case 'pa':
      return L10nPa();
    case 'pl':
      return L10nPl();
    case 'pt':
      return L10nPt();
    case 'ro':
      return L10nRo();
    case 'ru':
      return L10nRu();
    case 'sk':
      return L10nSk();
    case 'sl':
      return L10nSl();
    case 'sv':
      return L10nSv();
    case 'ta':
      return L10nTa();
    case 'te':
      return L10nTe();
    case 'th':
      return L10nTh();
    case 'tr':
      return L10nTr();
    case 'uk':
      return L10nUk();
    case 'ur':
      return L10nUr();
    case 'vi':
      return L10nVi();
    case 'zh':
      return L10nZh();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
