// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Conversor';

  @override
  String ratesOffline(String date) {
    return 'Tasas sin conexión · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'Actualizado $age · $date';
  }

  @override
  String get ageJustNow => 'ahora mismo';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'hace $count min');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'hace $count h');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'ayer';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: 'hace $count días', one: 'hace $count día');
    return '$_temp0';
  }

  @override
  String get refreshRates => 'Actualizar tasas';

  @override
  String get share => 'Compartir';

  @override
  String get currencies => 'Monedas';

  @override
  String get exchangeRates => 'Tipos de cambio';

  @override
  String get ownRates => 'Tasas propias';

  @override
  String get settings => 'Ajustes';

  @override
  String get addCurrency => 'Añadir moneda';

  @override
  String get changeCurrency => 'Cambiar moneda';

  @override
  String get copy => 'Copiar';

  @override
  String get paste => 'Pegar';

  @override
  String get remove => 'Quitar';

  @override
  String replaceCurrency(String code) {
    return 'Reemplazar $code';
  }

  @override
  String get copied => 'Copiado';

  @override
  String get clipboardNoNumber => 'No hay ningún número en el portapapeles';

  @override
  String get dragToReorder => 'Arrastra para reordenar';

  @override
  String get ownRate => 'Tasa propia';

  @override
  String removeCurrency(String code) {
    return 'Quitar $code';
  }

  @override
  String get backspace => 'Borrar';

  @override
  String get add => 'Añadir';

  @override
  String get chooseCurrency => 'Elegir moneda';

  @override
  String get searchCodeOrName => 'Buscar código o nombre';

  @override
  String get notFound => 'Sin resultados';

  @override
  String get addToFavorites => 'Añadir a favoritos';

  @override
  String get removeFromFavorites => 'Quitar de favoritos';

  @override
  String get currencyToOverride => 'Moneda a personalizar';

  @override
  String get useOwnRates => 'Usar tasas propias';

  @override
  String get useOwnRatesSubtitle => 'Sustituir las tasas del mercado por tus propios valores';

  @override
  String get ownRatesEmpty =>
      'Aún no hay tasas propias. Añade una para usar, por ejemplo, la tasa de tu banco o casa de cambio en lugar de la del mercado.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'Mercado: $amount';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String ownRateFor(String code) {
    return 'Tasa propia de $code';
  }

  @override
  String get ratePerOneOf => 'Tasa por 1 de…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get search => 'Buscar';

  @override
  String ratesOf(String name, String date) {
    return '$name · tasas del $date';
  }

  @override
  String get baseCurrency => 'Moneda base';

  @override
  String get decimalPlaces => 'Decimales';

  @override
  String get decimalPlacesSubtitle => 'Los importes menores que 1 siempre conservan 3 cifras significativas';

  @override
  String get keypadVibration => 'Vibración del teclado';

  @override
  String get theme => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String ratesBuiltIn(String date) {
    return 'Tasas sin conexión integradas del $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'Tasas del $date, descargadas $age';
  }

  @override
  String get refreshNow => 'Actualizar ahora';

  @override
  String get ratesRefreshed => 'Tasas actualizadas';

  @override
  String offlineError(String date) {
    return 'Sin conexión. Se muestran las tasas del $date.';
  }

  @override
  String get aboutRates =>
      'Las tasas proceden de la API libre y gratuita fawazahmed0 currency-api (CC0) y se actualizan a diario. Son tasas de referencia solo a título informativo, no cotizaciones para operar.\n\nSin anuncios, sin cuentas, sin rastreo.';
}
