// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Converter';

  @override
  String ratesOffline(String date) {
    return 'Offline rates · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'Updated $age · $date';
  }

  @override
  String get ageJustNow => 'just now';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count min ago', one: '1 min ago');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count h ago', one: '1 h ago');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'yesterday';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count d ago', one: '1 d ago');
    return '$_temp0';
  }

  @override
  String get refreshRates => 'Refresh rates';

  @override
  String get share => 'Share';

  @override
  String get currencies => 'Currencies';

  @override
  String get exchangeRates => 'Exchange rates';

  @override
  String get ownRates => 'Own rates';

  @override
  String get settings => 'Settings';

  @override
  String get addCurrency => 'Add currency';

  @override
  String get changeCurrency => 'Change currency';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get remove => 'Remove';

  @override
  String replaceCurrency(String code) {
    return 'Replace $code';
  }

  @override
  String get copied => 'Copied';

  @override
  String get clipboardNoNumber => 'Clipboard has no number';

  @override
  String get dragToReorder => 'Drag to reorder';

  @override
  String get ownRate => 'Own rate';

  @override
  String removeCurrency(String code) {
    return 'Remove $code';
  }

  @override
  String get backspace => 'Backspace';

  @override
  String get add => 'Add';

  @override
  String get chooseCurrency => 'Choose currency';

  @override
  String get searchCodeOrName => 'Search code or name';

  @override
  String get notFound => 'Not found';

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get currencyToOverride => 'Currency to override';

  @override
  String get useOwnRates => 'Use own rates';

  @override
  String get useOwnRatesSubtitle => 'Override market rates with your own values';

  @override
  String get ownRatesEmpty =>
      'No own rates yet. Add one to use, say, your bank\'s or exchange office\'s rate instead of the market rate.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'Market: $amount';
  }

  @override
  String get delete => 'Delete';

  @override
  String ownRateFor(String code) {
    return 'Own rate for $code';
  }

  @override
  String get ratePerOneOf => 'Rate is per 1 of…';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get search => 'Search';

  @override
  String ratesOf(String name, String date) {
    return '$name · rates of $date';
  }

  @override
  String get baseCurrency => 'Base currency';

  @override
  String get decimalPlaces => 'Decimal places';

  @override
  String get decimalPlacesSubtitle => 'Amounts below 1 always keep 3 significant digits';

  @override
  String get keypadVibration => 'Keypad vibration';

  @override
  String get zeroKeys => 'Zero keys';

  @override
  String get theme => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get language => 'Language';

  @override
  String get languageName => 'English';

  @override
  String get languageSystem => 'System default';

  @override
  String ratesBuiltIn(String date) {
    return 'Built-in offline rates of $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'Rates of $date, downloaded $age';
  }

  @override
  String get refreshNow => 'Refresh now';

  @override
  String get ratesRefreshed => 'Rates updated';

  @override
  String offlineError(String date) {
    return 'No connection. Showing rates from $date.';
  }

  @override
  String get aboutRates =>
      'Rates come from the free, open fawazahmed0 currency-api (CC0) and are updated daily. They are reference rates for information only, not trading quotes.\n\nNo ads, no accounts, no tracking.';

  @override
  String get donate => 'Buy me a coffee';

  @override
  String get donateSubtitle => 'Free and ad-free. Tips help keep it that way.';

  @override
  String get linkError => 'Couldn\'t open the link';
}
