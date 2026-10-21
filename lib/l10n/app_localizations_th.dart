// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'แปลงสกุลเงิน';

  @override
  String ratesOffline(String date) {
    return 'อัตราออฟไลน์ · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return 'อัปเดตเมื่อ $age · $date';
  }

  @override
  String get ageJustNow => 'เมื่อสักครู่';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count นาทีที่แล้ว');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count ชม. ที่แล้ว');
    return '$_temp0';
  }

  @override
  String get ageYesterday => 'เมื่อวาน';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count วันที่แล้ว');
    return '$_temp0';
  }

  @override
  String get refreshRates => 'รีเฟรชอัตรา';

  @override
  String get share => 'แชร์';

  @override
  String get currencies => 'สกุลเงิน';

  @override
  String get exchangeRates => 'อัตราแลกเปลี่ยน';

  @override
  String get ownRates => 'อัตราของฉัน';

  @override
  String get settings => 'การตั้งค่า';

  @override
  String get addCurrency => 'เพิ่มสกุลเงิน';

  @override
  String get changeCurrency => 'เปลี่ยนสกุลเงิน';

  @override
  String get copy => 'คัดลอก';

  @override
  String get paste => 'วาง';

  @override
  String get remove => 'นำออก';

  @override
  String replaceCurrency(String code) {
    return 'แทนที่ $code';
  }

  @override
  String get copied => 'คัดลอกแล้ว';

  @override
  String get clipboardNoNumber => 'ไม่มีตัวเลขในคลิปบอร์ด';

  @override
  String get dragToReorder => 'ลากเพื่อจัดลำดับ';

  @override
  String get ownRate => 'อัตราของฉัน';

  @override
  String removeCurrency(String code) {
    return 'นำ $code ออก';
  }

  @override
  String get backspace => 'ลบ';

  @override
  String get add => 'เพิ่ม';

  @override
  String get chooseCurrency => 'เลือกสกุลเงิน';

  @override
  String get searchCodeOrName => 'ค้นหารหัสหรือชื่อ';

  @override
  String get notFound => 'ไม่พบผลลัพธ์';

  @override
  String get addToFavorites => 'เพิ่มในรายการโปรด';

  @override
  String get removeFromFavorites => 'นำออกจากรายการโปรด';

  @override
  String get currencyToOverride => 'สกุลเงินที่จะกำหนดอัตราเอง';

  @override
  String get useOwnRates => 'ใช้อัตราของฉัน';

  @override
  String get useOwnRatesSubtitle => 'ใช้ค่าที่กำหนดเองแทนอัตราตลาด';

  @override
  String get ownRatesEmpty => 'ยังไม่มีอัตราของคุณ เพิ่มอัตรา เช่น อัตราของธนาคารหรือร้านแลกเงิน เพื่อใช้แทนอัตราตลาด';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return 'ตลาด: $amount';
  }

  @override
  String get delete => 'ลบ';

  @override
  String ownRateFor(String code) {
    return 'อัตราของฉันสำหรับ $code';
  }

  @override
  String get ratePerOneOf => 'อัตราต่อ 1 หน่วยของ…';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get save => 'บันทึก';

  @override
  String get search => 'ค้นหา';

  @override
  String ratesOf(String name, String date) {
    return '$name · อัตรา ณ $date';
  }

  @override
  String get baseCurrency => 'สกุลเงินหลัก';

  @override
  String get decimalPlaces => 'ตำแหน่งทศนิยม';

  @override
  String get decimalPlacesSubtitle => 'จำนวนที่น้อยกว่า 1 จะแสดงเลขนัยสำคัญ 3 หลักเสมอ';

  @override
  String get keypadVibration => 'สั่นเมื่อกดแป้น';

  @override
  String get theme => 'ธีม';

  @override
  String get themeSystem => 'ตามระบบ';

  @override
  String get themeLight => 'สว่าง';

  @override
  String get themeDark => 'มืด';

  @override
  String ratesBuiltIn(String date) {
    return 'อัตราออฟไลน์ในตัว ณ $date';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return 'อัตรา ณ $date ดาวน์โหลดเมื่อ $age';
  }

  @override
  String get refreshNow => 'รีเฟรชเดี๋ยวนี้';

  @override
  String get ratesRefreshed => 'อัปเดตอัตราแล้ว';

  @override
  String offlineError(String date) {
    return 'ไม่มีการเชื่อมต่อ กำลังแสดงอัตรา ณ $date';
  }

  @override
  String get aboutRates =>
      'อัตรามาจาก fawazahmed0 currency-api ซึ่งใช้ได้ฟรีและเป็นข้อมูลเปิด (CC0) และอัปเดตทุกวัน เป็นอัตราอ้างอิงเพื่อเป็นข้อมูลเท่านั้น ไม่ใช่ราคาซื้อขาย\n\nไม่มีโฆษณา ไม่ต้องมีบัญชี ไม่มีการติดตาม';
}
