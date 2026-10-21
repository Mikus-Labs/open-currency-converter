import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
    Locale('th'),
    Locale('zh'),
  ];

  /// App name, shown in the title bar and task switcher. Keep it short.
  ///
  /// In en, this message translates to:
  /// **'Converter'**
  String get appTitle;

  /// Subtitle under the app title when rates have never been downloaded; the built-in rates are used. {date} is the rates date (YYYY-MM-DD).
  ///
  /// In en, this message translates to:
  /// **'Offline rates · {date}'**
  String ratesOffline(String date);

  /// Subtitle under the app title. {age} is a relative time such as "3 h ago" (from the age* messages), {date} is the rates date (YYYY-MM-DD).
  ///
  /// In en, this message translates to:
  /// **'Updated {age} · {date}'**
  String ratesUpdated(String age, String date);

  /// Relative time, inserted mid-sentence into ratesUpdated and ratesDownloaded. Use lower case where the language allows.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get ageJustNow;

  /// Relative time in minutes, inserted mid-sentence. Abbreviations are fine; space is tight.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 min ago} other{{count} min ago}}'**
  String ageMinutes(int count);

  /// Relative time in hours, inserted mid-sentence. Abbreviations are fine; space is tight.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 h ago} other{{count} h ago}}'**
  String ageHours(int count);

  /// Relative time, inserted mid-sentence.
  ///
  /// In en, this message translates to:
  /// **'yesterday'**
  String get ageYesterday;

  /// Relative time in days, inserted mid-sentence. Abbreviations are fine; space is tight.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 d ago} other{{count} d ago}}'**
  String ageDays(int count);

  /// Tooltip for the button that downloads the latest exchange rates.
  ///
  /// In en, this message translates to:
  /// **'Refresh rates'**
  String get refreshRates;

  /// Tooltip for the button that shares all converted amounts as text.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// Menu item and screen title for managing the list of currencies on the converter.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currencies;

  /// Menu item and screen title for the table of all exchange rates; also a settings section heading.
  ///
  /// In en, this message translates to:
  /// **'Exchange rates'**
  String get exchangeRates;

  /// Menu item and screen title for custom exchange rates the user enters, e.g. their bank's rate.
  ///
  /// In en, this message translates to:
  /// **'Own rates'**
  String get ownRates;

  /// Menu item and screen title.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Button below the converter rows, and the title of the currency picker when adding one.
  ///
  /// In en, this message translates to:
  /// **'Add currency'**
  String get addCurrency;

  /// Action in the long-press menu of a converter row: swap this row to another currency.
  ///
  /// In en, this message translates to:
  /// **'Change currency'**
  String get changeCurrency;

  /// Action in the long-press menu of a converter row: copy the amount to the clipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// Action in the long-press menu of a converter row: paste a number from the clipboard into this row.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// Action in the long-press menu of a converter row: remove the currency from the converter.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Title of the currency picker when changing a row's currency. {code} is a currency code.
  ///
  /// In en, this message translates to:
  /// **'Replace {code}'**
  String replaceCurrency(String code);

  /// Short confirmation after copying an amount.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// Error when pasting and the clipboard text is not a number.
  ///
  /// In en, this message translates to:
  /// **'Clipboard has no number'**
  String get clipboardNoNumber;

  /// Tooltip on the drag handle of a converter row.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder'**
  String get dragToReorder;

  /// Tooltip on the marker shown next to a currency that uses a custom rate.
  ///
  /// In en, this message translates to:
  /// **'Own rate'**
  String get ownRate;

  /// Tooltip and screen-reader label for the remove button on a currency row. {code} is a currency code.
  ///
  /// In en, this message translates to:
  /// **'Remove {code}'**
  String removeCurrency(String code);

  /// Screen-reader label for the keypad key that deletes the last character.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get backspace;

  /// Floating button that adds an item (a currency or an own rate).
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// Default title of the currency picker.
  ///
  /// In en, this message translates to:
  /// **'Choose currency'**
  String get chooseCurrency;

  /// Hint in the search field of the currency picker.
  ///
  /// In en, this message translates to:
  /// **'Search code or name'**
  String get searchCodeOrName;

  /// Shown when a search matches no currencies.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// Tooltip for the star button; favourites are listed first in the currency picker.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// Tooltip for the filled star button.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// Title of the currency picker when adding an own rate.
  ///
  /// In en, this message translates to:
  /// **'Currency to override'**
  String get currencyToOverride;

  /// Switch that turns all own rates on or off.
  ///
  /// In en, this message translates to:
  /// **'Use own rates'**
  String get useOwnRates;

  /// Explanation under the useOwnRates switch.
  ///
  /// In en, this message translates to:
  /// **'Override market rates with your own values'**
  String get useOwnRatesSubtitle;

  /// Shown on the own rates screen when none have been added.
  ///
  /// In en, this message translates to:
  /// **'No own rates yet. Add one to use, say, your bank\'s or exchange office\'s rate instead of the market rate.'**
  String get ownRatesEmpty;

  /// A rate between two currencies. {from} and {to} are currency codes, {amount} is a formatted number. Change the order only if the language needs it.
  ///
  /// In en, this message translates to:
  /// **'1 {from} = {amount} {to}'**
  String rateEquation(String from, String amount, String to);

  /// Subtitle of an own rate showing the market rate for comparison. {amount} is a formatted number.
  ///
  /// In en, this message translates to:
  /// **'Market: {amount}'**
  String marketRate(String amount);

  /// Tooltip for the button that deletes an own rate.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Title of the dialog for entering an own rate. {code} is a currency code.
  ///
  /// In en, this message translates to:
  /// **'Own rate for {code}'**
  String ownRateFor(String code);

  /// Title of the currency picker that chooses the base currency of an own rate ("1 USD = …").
  ///
  /// In en, this message translates to:
  /// **'Rate is per 1 of…'**
  String get ratePerOneOf;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Dialog button.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Hint in the search field of the exchange rates screen.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Subtitle of the base currency on the exchange rates screen. {name} is a currency name, {date} is the rates date (YYYY-MM-DD).
  ///
  /// In en, this message translates to:
  /// **'{name} · rates of {date}'**
  String ratesOf(String name, String date);

  /// Title of the currency picker for the base currency of the rates table.
  ///
  /// In en, this message translates to:
  /// **'Base currency'**
  String get baseCurrency;

  /// Setting: how many decimals amounts show.
  ///
  /// In en, this message translates to:
  /// **'Decimal places'**
  String get decimalPlaces;

  /// Explanation under the decimal places setting.
  ///
  /// In en, this message translates to:
  /// **'Amounts below 1 always keep 3 significant digits'**
  String get decimalPlacesSubtitle;

  /// Setting: vibrate when a keypad key is pressed.
  ///
  /// In en, this message translates to:
  /// **'Keypad vibration'**
  String get keypadVibration;

  /// Setting: light or dark appearance.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Theme option: follow the device setting.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// Theme option.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// Theme option.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// Exchange rates status when rates have never been downloaded. {date} is the rates date (YYYY-MM-DD).
  ///
  /// In en, this message translates to:
  /// **'Built-in offline rates of {date}'**
  String ratesBuiltIn(String date);

  /// Exchange rates status. {date} is the rates date (YYYY-MM-DD), {age} is a relative time such as "3 h ago" (from the age* messages).
  ///
  /// In en, this message translates to:
  /// **'Rates of {date}, downloaded {age}'**
  String ratesDownloaded(String date, String age);

  /// Tooltip for the button that downloads the latest rates.
  ///
  /// In en, this message translates to:
  /// **'Refresh now'**
  String get refreshNow;

  /// Confirmation after downloading the latest rates.
  ///
  /// In en, this message translates to:
  /// **'Rates updated'**
  String get ratesRefreshed;

  /// Error when rates could not be downloaded. {date} is the date of the rates still in use (YYYY-MM-DD).
  ///
  /// In en, this message translates to:
  /// **'No connection. Showing rates from {date}.'**
  String offlineError(String date);

  /// Note at the bottom of settings. Keep "fawazahmed0 currency-api" and "CC0" untranslated.
  ///
  /// In en, this message translates to:
  /// **'Rates come from the free, open fawazahmed0 currency-api (CC0) and are updated daily. They are reference rates for information only, not trading quotes.\n\nNo ads, no accounts, no tracking.'**
  String get aboutRates;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr', 'ru', 'th', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
