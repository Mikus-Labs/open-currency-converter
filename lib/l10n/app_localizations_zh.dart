// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '货币换算';

  @override
  String ratesOffline(String date) {
    return '离线汇率 · $date';
  }

  @override
  String ratesUpdated(String age, String date) {
    return '$age更新 · $date';
  }

  @override
  String get ageJustNow => '刚刚';

  @override
  String ageMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 分钟前');
    return '$_temp0';
  }

  @override
  String ageHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 小时前');
    return '$_temp0';
  }

  @override
  String get ageYesterday => '昨天';

  @override
  String ageDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(count, locale: localeName, other: '$count 天前');
    return '$_temp0';
  }

  @override
  String get refreshRates => '刷新汇率';

  @override
  String get share => '分享';

  @override
  String get currencies => '货币';

  @override
  String get exchangeRates => '汇率';

  @override
  String get ownRates => '自定义汇率';

  @override
  String get settings => '设置';

  @override
  String get addCurrency => '添加货币';

  @override
  String get changeCurrency => '更换货币';

  @override
  String get copy => '复制';

  @override
  String get paste => '粘贴';

  @override
  String get remove => '移除';

  @override
  String replaceCurrency(String code) {
    return '替换 $code';
  }

  @override
  String get copied => '已复制';

  @override
  String get clipboardNoNumber => '剪贴板中没有数字';

  @override
  String get dragToReorder => '拖动以排序';

  @override
  String get ownRate => '自定义汇率';

  @override
  String removeCurrency(String code) {
    return '移除 $code';
  }

  @override
  String get backspace => '退格';

  @override
  String get add => '添加';

  @override
  String get chooseCurrency => '选择货币';

  @override
  String get searchCodeOrName => '搜索代码或名称';

  @override
  String get notFound => '未找到';

  @override
  String get addToFavorites => '添加到收藏';

  @override
  String get removeFromFavorites => '从收藏中移除';

  @override
  String get currencyToOverride => '要自定义汇率的货币';

  @override
  String get useOwnRates => '使用自定义汇率';

  @override
  String get useOwnRatesSubtitle => '用你自己的数值替代市场汇率';

  @override
  String get ownRatesEmpty => '还没有自定义汇率。添加一个，即可使用银行或兑换点的汇率代替市场汇率。';

  @override
  String rateEquation(String from, String amount, String to) {
    return '1 $from = $amount $to';
  }

  @override
  String marketRate(String amount) {
    return '市场：$amount';
  }

  @override
  String get delete => '删除';

  @override
  String ownRateFor(String code) {
    return '$code 的自定义汇率';
  }

  @override
  String get ratePerOneOf => '汇率按每 1 单位…';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get search => '搜索';

  @override
  String ratesOf(String name, String date) {
    return '$name · $date 汇率';
  }

  @override
  String get baseCurrency => '基准货币';

  @override
  String get decimalPlaces => '小数位数';

  @override
  String get decimalPlacesSubtitle => '小于 1 的金额始终保留 3 位有效数字';

  @override
  String get keypadVibration => '按键振动';

  @override
  String get theme => '主题';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String ratesBuiltIn(String date) {
    return '内置离线汇率（$date）';
  }

  @override
  String ratesDownloaded(String date, String age) {
    return '$date 汇率，$age下载';
  }

  @override
  String get refreshNow => '立即刷新';

  @override
  String get ratesRefreshed => '汇率已更新';

  @override
  String offlineError(String date) {
    return '无网络连接。正在显示 $date 的汇率。';
  }

  @override
  String get aboutRates => '汇率来自免费开放的 fawazahmed0 currency-api（CC0），每日更新。仅供参考，并非交易报价。\n\n无广告、无账户、无跟踪。';
}
