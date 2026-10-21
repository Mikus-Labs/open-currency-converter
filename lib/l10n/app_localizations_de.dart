// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Umrechner';

  @override
  String ratesOffline(String date) {
    return 'Offline-Kurse · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'Aktualisiert $age · $date';
  }

  @override
  String get ageJustNow => 'gerade eben';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'vor $count Min.');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'vor $count Std.');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'gestern';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'vor $count Tagen', one: 'vor 1 Tag');
    return '$_temp0';
  }

  @override
  String get refreshRates => 'Kurse aktualisieren';

  @override
  String get share => 'Teilen';

  @override
  String get currencies => 'Währungen';

  @override
  String get exchangeRates => 'Wechselkurse';

  @override
  String get ownRates => 'Eigene Kurse';

  @override
  String get settings => 'Einstellungen';

  @override
  String get addCurrency => 'Währung hinzufügen';

  @override
  String get changeCurrency => 'Währung ändern';

  @override
  String get copy => 'Kopieren';

  @override
  String get paste => 'Einfügen';

  @override
  String get remove => 'Entfernen';

  @override
  String replaceCurrency(String code) {
    return '$code ersetzen';
  }

  @override
  String get copied => 'Kopiert';

  @override
  String get clipboardNoNumber => 'Keine Zahl in der Zwischenablage';

  @override
  String get dragToReorder => 'Zum Sortieren ziehen';

  @override
  String get ownRate => 'Eigener Kurs';

  @override
  String removeCurrency(String code) {
    return '$code entfernen';
  }

  @override
  String get backspace => 'Löschen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get chooseCurrency => 'Währung wählen';

  @override
  String get searchCodeOrName => 'Code oder Name suchen';

  @override
  String get notFound => 'Nichts gefunden';

  @override
  String get addToFavorites => 'Zu Favoriten hinzufügen';

  @override
  String get removeFromFavorites => 'Aus Favoriten entfernen';

  @override
  String get currencyToOverride => 'Währung für eigenen Kurs';

  @override
  String get useOwnRates => 'Eigene Kurse verwenden';

  @override
  String get useOwnRatesSubtitle => 'Marktkurse durch eigene Werte ersetzen';

  @override
  String get ownRatesEmpty =>
      'Noch keine eigenen Kurse. Füge einen hinzu, um z. B. den Kurs deiner Bank oder Wechselstube statt des Marktkurses zu verwenden.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'Markt: $amount';
  }

  @override
  String get delete => 'Löschen';

  @override
  String ownRateFor(String code) {
    return 'Eigener Kurs für $code';
  }

  @override
  String get ratePerOneOf => 'Kurs pro 1 …';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get save => 'Speichern';

  @override
  String get search => 'Suchen';

  @override
  String ratesOf(String name, String date) {
    return '$name · Kurse vom $date';
  }

  @override
  String get baseCurrency => 'Basiswährung';

  @override
  String get decimalPlaces => 'Nachkommastellen';

  @override
  String get decimalPlacesSubtitle => 'Beträge unter 1 behalten immer 3 signifikante Stellen';

  @override
  String get keypadVibration => 'Tastenvibration';

  @override
  String get theme => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String ratesBuiltIn(String date) {
    return 'Integrierte Offline-Kurse vom $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'Kurse vom $date, geladen $age';
  }

  @override
  String get refreshNow => 'Jetzt aktualisieren';

  @override
  String get ratesRefreshed => 'Kurse aktualisiert';

  @override
  String offlineError(String date) {
    return 'Keine Verbindung. Kurse vom $date werden angezeigt.';
  }

  @override
  String get aboutRates =>
      'Die Kurse stammen aus der freien, offenen fawazahmed0 currency-api (CC0) und werden täglich aktualisiert. Es sind Referenzkurse nur zur Information, keine Handelskurse.\n\nKeine Werbung, keine Konten, kein Tracking.';
}
