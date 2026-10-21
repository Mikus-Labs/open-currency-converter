// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'محوّل العملات';

  @override
  String ratesOffline(String date) {
    return 'أسعار دون اتصال · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'آخر تحديث $age · $date';
  }

  @override
  String get ageJustNow => 'الآن';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count دقيقة',
      many: 'منذ $count دقيقة',
      few: 'منذ $count دقائق',
      two: 'منذ دقيقتين',
      one: 'منذ دقيقة',
      zero: 'منذ $count دقيقة',
    );
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count ساعة',
      many: 'منذ $count ساعة',
      few: 'منذ $count ساعات',
      two: 'منذ ساعتين',
      one: 'منذ ساعة',
      zero: 'منذ $count ساعة',
    );
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'أمس';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يوم',
      many: 'منذ $count يومًا',
      few: 'منذ $count أيام',
      two: 'منذ يومين',
      one: 'منذ يوم',
      zero: 'منذ $count يوم',
    );
    return '$_temp0';
  }

  @override
  String get refreshRates => 'تحديث الأسعار';

  @override
  String get share => 'مشاركة';

  @override
  String get currencies => 'العملات';

  @override
  String get exchangeRates => 'أسعار الصرف';

  @override
  String get ownRates => 'أسعاري الخاصة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get addCurrency => 'إضافة عملة';

  @override
  String get changeCurrency => 'تغيير العملة';

  @override
  String get copy => 'نسخ';

  @override
  String get paste => 'لصق';

  @override
  String get remove => 'إزالة';

  @override
  String replaceCurrency(String code) {
    return 'استبدال $code';
  }

  @override
  String get copied => 'تم النسخ';

  @override
  String get clipboardNoNumber => 'لا يوجد رقم في الحافظة';

  @override
  String get dragToReorder => 'اسحب لإعادة الترتيب';

  @override
  String get ownRate => 'سعر خاص';

  @override
  String removeCurrency(String code) {
    return 'إزالة $code';
  }

  @override
  String get backspace => 'حذف';

  @override
  String get add => 'إضافة';

  @override
  String get chooseCurrency => 'اختر عملة';

  @override
  String get searchCodeOrName => 'ابحث بالرمز أو الاسم';

  @override
  String get notFound => 'لا توجد نتائج';

  @override
  String get addToFavorites => 'إضافة إلى المفضلة';

  @override
  String get removeFromFavorites => 'إزالة من المفضلة';

  @override
  String get currencyToOverride => 'العملة المراد تخصيص سعرها';

  @override
  String get useOwnRates => 'استخدام أسعاري الخاصة';

  @override
  String get useOwnRatesSubtitle => 'استبدال أسعار السوق بقيمك الخاصة';

  @override
  String get ownRatesEmpty =>
      'لا توجد أسعار خاصة بعد. أضف سعرًا لاستخدام سعر مصرفك أو مكتب الصرافة مثلًا بدلًا من سعر السوق.';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'السوق: $amount';
  }

  @override
  String get delete => 'حذف';

  @override
  String ownRateFor(String code) {
    return 'سعر خاص لـ $code';
  }

  @override
  String get ratePerOneOf => 'السعر لكل 1 من…';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get search => 'بحث';

  @override
  String ratesOf(String name, String date) {
    return '$name · أسعار $date';
  }

  @override
  String get baseCurrency => 'العملة الأساسية';

  @override
  String get decimalPlaces => 'المنازل العشرية';

  @override
  String get decimalPlacesSubtitle => 'المبالغ الأقل من 1 تحتفظ دائمًا بـ 3 أرقام معنوية';

  @override
  String get keypadVibration => 'اهتزاز لوحة المفاتيح';

  @override
  String get theme => 'المظهر';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String ratesBuiltIn(String date) {
    return 'أسعار مدمجة دون اتصال بتاريخ $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'أسعار $date، تم تنزيلها $age';
  }

  @override
  String get refreshNow => 'تحديث الآن';

  @override
  String get ratesRefreshed => 'تم تحديث الأسعار';

  @override
  String offlineError(String date) {
    return 'لا يوجد اتصال. يتم عرض أسعار $date.';
  }

  @override
  String get aboutRates =>
      'تأتي الأسعار من واجهة fawazahmed0 currency-api المجانية والمفتوحة (CC0) وتُحدَّث يوميًا. وهي أسعار مرجعية للعلم فقط، وليست أسعار تداول.\n\nبلا إعلانات، بلا حسابات، بلا تتبع.';
}
