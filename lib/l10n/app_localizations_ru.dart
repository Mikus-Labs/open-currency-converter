// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Конвертер';

  @override
  String ratesOffline(String date) {
    return 'Офлайн-курсы · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'Обновлено $age · $date';
  }

  @override
  String get ageJustNow => 'только что';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count мин назад');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count ч назад');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'вчера';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дня назад',
      many: '$count дней назад',
      few: '$count дня назад',
      one: '$count день назад',
    );
    return '$_temp0';
  }

  @override
  String get refreshRates => 'Обновить курсы';

  @override
  String get share => 'Поделиться';

  @override
  String get currencies => 'Валюты';

  @override
  String get exchangeRates => 'Курсы валют';

  @override
  String get ownRates => 'Свои курсы';

  @override
  String get settings => 'Настройки';

  @override
  String get addCurrency => 'Добавить валюту';

  @override
  String get changeCurrency => 'Сменить валюту';

  @override
  String get copy => 'Копировать';

  @override
  String get paste => 'Вставить';

  @override
  String get remove => 'Убрать';

  @override
  String replaceCurrency(String code) {
    return 'Заменить $code';
  }

  @override
  String get copied => 'Скопировано';

  @override
  String get clipboardNoNumber => 'В буфере обмена нет числа';

  @override
  String get dragToReorder => 'Перетащите, чтобы изменить порядок';

  @override
  String get ownRate => 'Свой курс';

  @override
  String removeCurrency(String code) {
    return 'Убрать $code';
  }

  @override
  String get backspace => 'Стереть';

  @override
  String get add => 'Добавить';

  @override
  String get chooseCurrency => 'Выберите валюту';

  @override
  String get searchCodeOrName => 'Поиск по коду или названию';

  @override
  String get notFound => 'Ничего не найдено';

  @override
  String get filterAll => 'Все';

  @override
  String get filterNoCrypto => 'Без крипто';

  @override
  String get filterCryptoOnly => 'Только крипто';

  @override
  String get kindFiat => 'Фиат';

  @override
  String get kindCrypto => 'Крипто';

  @override
  String get kindMetal => 'Металл';

  @override
  String get addToFavorites => 'Добавить в избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get currencyToOverride => 'Валюта для своего курса';

  @override
  String get useOwnRates => 'Использовать свои курсы';

  @override
  String get useOwnRatesSubtitle => 'Заменять рыночные курсы своими значениями';

  @override
  String get ownRatesEmpty =>
      'Своих курсов пока нет. Добавьте, например, курс своего банка или обменника, чтобы использовать его вместо рыночного.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'Рынок: $amount';
  }

  @override
  String get delete => 'Удалить';

  @override
  String ownRateFor(String code) {
    return 'Свой курс для $code';
  }

  @override
  String get ratePerOneOf => 'Курс за 1 …';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get search => 'Поиск';

  @override
  String ratesOf(String name, String date) {
    return '$name · курсы на $date';
  }

  @override
  String get baseCurrency => 'Базовая валюта';

  @override
  String get decimalPlaces => 'Знаков после запятой';

  @override
  String get decimalPlacesSubtitle => 'Суммы меньше 1 всегда сохраняют 3 значащие цифры';

  @override
  String get keypadVibration => 'Вибрация клавиатуры';

  @override
  String get zeroKeys => 'Клавиши нулей';

  @override
  String get theme => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get language => 'Язык';

  @override
  String get languageName => 'Русский';

  @override
  String get languageSystem => 'Как в системе';

  @override
  String ratesBuiltIn(String date) {
    return 'Встроенные офлайн-курсы на $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'Курсы на $date, загружены $age';
  }

  @override
  String get refreshNow => 'Обновить сейчас';

  @override
  String get ratesRefreshed => 'Курсы обновлены';

  @override
  String offlineError(String date) {
    return 'Нет подключения. Показаны курсы на $date.';
  }

  @override
  String get aboutRates =>
      'Курсы берутся из бесплатного открытого fawazahmed0 currency-api (CC0) и обновляются ежедневно. Это справочные курсы только для информации, а не торговые котировки.\n\nБез рекламы, аккаунтов и слежки.';

  @override
  String get donate => 'Угостить кофе';

  @override
  String get donateSubtitle => 'Бесплатно и без рекламы. Ваша поддержка помогает сохранить это.';

  @override
  String get linkError => 'Не удалось открыть ссылку';
}
