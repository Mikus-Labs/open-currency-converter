// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Convertisseur';

  @override
  String ratesOffline(String date) {
    return 'Taux hors ligne · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'Mis à jour $age · $date';
  }

  @override
  String get ageJustNow => 'à l’instant';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'il y a $count min');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'il y a $count h');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'hier';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'il y a $count jours',
      one: 'il y a $count jour',
    );
    return '$_temp0';
  }

  @override
  String get refreshRates => 'Actualiser les taux';

  @override
  String get share => 'Partager';

  @override
  String get currencies => 'Devises';

  @override
  String get exchangeRates => 'Taux de change';

  @override
  String get ownRates => 'Taux personnels';

  @override
  String get settings => 'Paramètres';

  @override
  String get addCurrency => 'Ajouter une devise';

  @override
  String get changeCurrency => 'Changer de devise';

  @override
  String get copy => 'Copier';

  @override
  String get paste => 'Coller';

  @override
  String get remove => 'Retirer';

  @override
  String replaceCurrency(String code) {
    return 'Remplacer $code';
  }

  @override
  String get copied => 'Copié';

  @override
  String get clipboardNoNumber => 'Aucun nombre dans le presse-papiers';

  @override
  String get dragToReorder => 'Faire glisser pour réorganiser';

  @override
  String get ownRate => 'Taux personnel';

  @override
  String removeCurrency(String code) {
    return 'Retirer $code';
  }

  @override
  String get backspace => 'Effacer';

  @override
  String get add => 'Ajouter';

  @override
  String get chooseCurrency => 'Choisir une devise';

  @override
  String get searchCodeOrName => 'Rechercher un code ou un nom';

  @override
  String get notFound => 'Aucun résultat';

  @override
  String get addToFavorites => 'Ajouter aux favoris';

  @override
  String get removeFromFavorites => 'Retirer des favoris';

  @override
  String get currencyToOverride => 'Devise à personnaliser';

  @override
  String get useOwnRates => 'Utiliser mes taux';

  @override
  String get useOwnRatesSubtitle => 'Remplacer les taux du marché par vos propres valeurs';

  @override
  String get ownRatesEmpty =>
      'Aucun taux personnel. Ajoutez-en un pour utiliser, par exemple, le taux de votre banque ou d’un bureau de change au lieu du taux du marché.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'Marché : $amount';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String ownRateFor(String code) {
    return 'Taux personnel pour $code';
  }

  @override
  String get ratePerOneOf => 'Taux pour 1 …';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get search => 'Rechercher';

  @override
  String ratesOf(String name, String date) {
    return '$name · taux du $date';
  }

  @override
  String get baseCurrency => 'Devise de base';

  @override
  String get decimalPlaces => 'Décimales';

  @override
  String get decimalPlacesSubtitle => 'Les montants inférieurs à 1 gardent toujours 3 chiffres significatifs';

  @override
  String get keypadVibration => 'Vibration du clavier';

  @override
  String get zeroKeys => 'Touches zéro';

  @override
  String get theme => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get language => 'Langue';

  @override
  String get languageName => 'Français';

  @override
  String get languageSystem => 'Langue du système';

  @override
  String ratesBuiltIn(String date) {
    return 'Taux hors ligne intégrés du $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'Taux du $date, téléchargés $age';
  }

  @override
  String get refreshNow => 'Actualiser';

  @override
  String get ratesRefreshed => 'Taux mis à jour';

  @override
  String offlineError(String date) {
    return 'Pas de connexion. Affichage des taux du $date.';
  }

  @override
  String get aboutRates =>
      'Les taux proviennent de l’API libre et gratuite fawazahmed0 currency-api (CC0) et sont mis à jour chaque jour. Ce sont des taux de référence donnés à titre indicatif, pas des cotations de marché.\n\nSans publicité, sans compte, sans pistage.';

  @override
  String get donate => 'Offrez-moi un café';

  @override
  String get donateSubtitle => 'Gratuit et sans publicité. Vos dons aident à le rester.';

  @override
  String get linkError => 'Impossible d\'ouvrir le lien';
}
