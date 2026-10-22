import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'currency_kind.dart';
import 'expression.dart' as calc;
import 'format.dart';
import 'l10n/app_localizations.dart';
import 'rates.dart';

/// A user-entered rate: 1 [base] = [value] of the overridden currency.
class OwnRate {
  const OwnRate({required this.base, required this.value});

  final String base;
  final double value;

  Map<String, dynamic> toJson() => {'base': base, 'value': value};
  factory OwnRate.fromJson(Map<String, dynamic> json) =>
      OwnRate(base: json['base'] as String, value: (json['value'] as num).toDouble());
}

/// Which multi-zero keys the keypad shows beside 0.
enum ZeroKeys { both, doubleZero, tripleZero }

class AppState extends ChangeNotifier {
  AppState({RatesService? service, this._prefs}) : _service = service ?? RatesService();

  static const _stateKey = 'state_v1';
  static const _ratesKey = 'rates_v1';
  static const staleAfter = Duration(hours: 6);

  final RatesService _service;
  SharedPreferences? _prefs;

  late RatesSnapshot snapshot;

  /// When rates were last downloaded; null while on the bundled snapshot.
  DateTime? fetchedAt;
  bool loading = false;

  List<String> selected = ['usd', 'eur', 'gbp', 'jpy', 'cny'];
  int active = 0;

  /// Keypad expression for the active row.
  String expr = '100';

  /// After switching rows the prefilled value is replaced by the next digit.
  bool _replaceOnType = true;

  Set<String> favorites = {};
  Map<String, OwnRate> ownRates = {};
  bool useOwnRates = true;
  int decimals = 2;
  bool haptics = true;
  ZeroKeys zeroKeys = ZeroKeys.both;
  CurrencyFilter currencyFilter = CurrencyFilter.all;
  ThemeMode themeMode = ThemeMode.system;

  /// App language, or null to follow the device.
  Locale? locale;

  /// Total time the app has been on screen, for the one-time rating prompt.
  Duration usage = Duration.zero;
  bool reviewRequested = false;

  /// Last keypad press, so the rating prompt doesn't interrupt typing.
  DateTime? lastInteraction;

  Future<void> load() async {
    snapshot = await RatesSnapshot.bundled();
    final SharedPreferences prefs;
    try {
      prefs = _prefs ??= await SharedPreferences.getInstance();
    } catch (e) {
      // Start without saved settings rather than hang on the launch screen.
      debugPrint('Settings storage unavailable: $e');
      notifyListeners();
      return;
    }
    final cached = prefs.getString(_ratesKey);
    if (cached != null) {
      try {
        final json = jsonDecode(cached) as Map<String, dynamic>;
        snapshot = RatesSnapshot.fromJson(json['snapshot'] as Map<String, dynamic>);
        fetchedAt = DateTime.tryParse(json['fetchedAt'] as String? ?? '');
      } catch (_) {
        // Corrupt cache: keep the bundled snapshot.
      }
    }
    final saved = prefs.getString(_stateKey);
    if (saved != null) {
      try {
        _restore(jsonDecode(saved) as Map<String, dynamic>);
      } catch (_) {
        // Ignore unreadable settings and start from defaults.
      }
    }
    selected = selected.where(snapshot.rates.containsKey).toList();
    if (selected.isEmpty) selected = ['usd', 'eur'];
    active = active.clamp(0, selected.length - 1);
    notifyListeners();
  }

  void _restore(Map<String, dynamic> json) {
    selected = List<String>.from(json['selected'] as List);
    active = json['active'] as int? ?? 0;
    expr = json['expr'] as String? ?? '100';
    favorites = Set<String>.from(json['favorites'] as List? ?? const []);
    ownRates = {
      for (final e in (json['ownRates'] as Map<String, dynamic>? ?? const {}).entries)
        e.key: OwnRate.fromJson(e.value as Map<String, dynamic>),
    };
    useOwnRates = json['useOwnRates'] as bool? ?? true;
    decimals = json['decimals'] as int? ?? 2;
    haptics = json['haptics'] as bool? ?? true;
    zeroKeys = ZeroKeys.values.asNameMap()[json['zeroKeys']] ?? ZeroKeys.both;
    currencyFilter = CurrencyFilter.values.asNameMap()[json['currencyFilter']] ?? CurrencyFilter.all;
    themeMode = ThemeMode.values[json['themeMode'] as int? ?? 0];
    locale = AppLocalizations.supportedLocales.where((l) => l.toLanguageTag() == json['locale']).firstOrNull;
    usage = Duration(seconds: json['usageSeconds'] as int? ?? 0);
    reviewRequested = json['reviewRequested'] as bool? ?? false;
  }

  void _save() {
    _prefs?.setString(
      _stateKey,
      jsonEncode({
        'selected': selected,
        'active': active,
        'expr': expr,
        'favorites': favorites.toList(),
        'ownRates': ownRates.map((k, v) => MapEntry(k, v.toJson())),
        'useOwnRates': useOwnRates,
        'decimals': decimals,
        'haptics': haptics,
        'zeroKeys': zeroKeys.name,
        'currencyFilter': currencyFilter.name,
        'themeMode': themeMode.index,
        'locale': locale?.toLanguageTag(),
        'usageSeconds': usage.inSeconds,
        'reviewRequested': reviewRequested,
      }),
    );
  }

  void _changed() {
    _save();
    notifyListeners();
  }

  // Rates & conversion

  bool get isStale => fetchedAt == null || DateTime.now().difference(fetchedAt!) > staleAfter;

  /// Downloads fresh rates. Returns false on failure, keeping the current rates.
  Future<bool> refresh() async {
    if (loading) return true;
    loading = true;
    notifyListeners();
    try {
      snapshot = await _service.fetch();
      fetchedAt = DateTime.now();
      await _prefs?.setString(
        _ratesKey,
        jsonEncode({'snapshot': snapshot.toJson(), 'fetchedAt': fetchedAt!.toIso8601String()}),
      );
      return true;
    } catch (_) {
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> refreshIfStale() async {
    if (isStale) await refresh();
  }

  String nameOf(String code) => snapshot.names[code] ?? code.toUpperCase();

  double? marketRate(String code) => snapshot.rates[code];

  /// Units of [code] per 1 USD, honouring own rates when enabled.
  double? rateOf(String code) {
    final own = useOwnRates ? ownRates[code] : null;
    if (own != null) {
      final base = marketRate(own.base);
      if (base != null) return own.value * base;
    }
    return marketRate(code);
  }

  double? convert(double amount, String from, String to) {
    final rFrom = rateOf(from), rTo = rateOf(to);
    if (rFrom == null || rTo == null) return null;
    return amount / rFrom * rTo;
  }

  bool hasOwnRate(String code) => useOwnRates && ownRates.containsKey(code);

  // Converter rows

  String get activeCode => selected[active];

  /// The amount entered on the active row (0 when empty or malformed).
  double get amount => calc.evaluate(expr) ?? 0;

  double? valueFor(int index) => index == active ? amount : convert(amount, activeCode, selected[index]);

  void setActive(int index) {
    if (index == active) return;
    final value = valueFor(index);
    active = index;
    expr = value == null ? '' : plainAmount(value, decimals);
    _replaceOnType = true;
    _changed();
  }

  void press(String key) {
    lastInteraction = DateTime.now();
    if (haptics) HapticFeedback.selectionClick();
    if (key == '=') {
      final value = calc.evaluate(expr);
      if (value != null) expr = plainAmount(value, decimals);
      _replaceOnType = true;
    } else {
      final startsFresh = _replaceOnType && !calc.operators.contains(key) && key != '%' && key != '⌫';
      expr = calc.applyKey(startsFresh ? '' : expr, key);
      _replaceOnType = false;
    }
    _changed();
  }

  /// Puts a pasted number into the active row. Returns false if unusable.
  bool paste(String text) {
    final cleaned = text.trim().replaceAll(RegExp(r'[\s,_]'), '').replaceAll('-', '−');
    final value = calc.evaluate(cleaned.replaceAll('*', '×').replaceAll('/', '÷').replaceAll('x', '×'));
    if (value == null) return false;
    expr = plainAmount(value, decimals);
    _replaceOnType = true;
    _changed();
    return true;
  }

  void replaceCurrency(int index, String code) {
    final existing = selected.indexOf(code);
    if (existing == index) return;
    if (existing != -1) {
      // Already shown: swap the two rows instead of duplicating.
      selected[existing] = selected[index];
    }
    selected[index] = code;
    _changed();
  }

  void addCurrency(String code) {
    if (selected.contains(code)) return;
    selected = [...selected, code];
    _changed();
  }

  void removeCurrency(int index) {
    if (selected.length <= 1) return;
    if (index == active) {
      // Carry the amount over to the row that becomes active.
      final next = index == 0 ? 1 : 0;
      final value = valueFor(next);
      selected = [...selected]..removeAt(index);
      active = 0;
      expr = value == null ? '' : plainAmount(value, decimals);
      _replaceOnType = true;
      _changed();
      return;
    }
    selected = [...selected]..removeAt(index);
    if (index < active) {
      active--;
    }
    _changed();
  }

  /// Moves a row; [newIndex] is the final position after removal.
  void reorder(int oldIndex, int newIndex) {
    final activeCode = this.activeCode;
    final list = [...selected];
    list.insert(newIndex, list.removeAt(oldIndex));
    selected = list;
    active = selected.indexOf(activeCode);
    _changed();
  }

  /// Text for sharing the current conversion, one currency per line.
  String shareText() {
    final lines = <String>[];
    for (var i = 0; i < selected.length; i++) {
      final v = valueFor(i);
      if (v != null) lines.add('${formatAmount(v, decimals)} ${selected[i].toUpperCase()}');
    }
    return lines.join('\n');
  }

  // Favorites, own rates, settings

  void toggleFavorite(String code) {
    favorites = {...favorites};
    if (!favorites.remove(code)) favorites.add(code);
    _changed();
  }

  void setOwnRate(String code, OwnRate rate) {
    ownRates = {...ownRates, code: rate};
    _changed();
  }

  void removeOwnRate(String code) {
    ownRates = {...ownRates}..remove(code);
    _changed();
  }

  void setUseOwnRates(bool value) {
    useOwnRates = value;
    _changed();
  }

  void setDecimals(int value) {
    decimals = value;
    _changed();
  }

  void setHaptics(bool value) {
    haptics = value;
    _changed();
  }

  void setZeroKeys(ZeroKeys value) {
    zeroKeys = value;
    _changed();
  }

  void setCurrencyFilter(CurrencyFilter value) {
    currencyFilter = value;
    _changed();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    _changed();
  }

  /// Counts time on screen. Saved every 30 s rather than every second.
  void addUsage(Duration value) {
    usage += value;
    if (usage.inSeconds % 30 == 0) _save();
  }

  void markReviewRequested() {
    reviewRequested = true;
    _save();
  }

  void setLocale(Locale? value) {
    locale = value;
    _changed();
  }
}

/// Makes the [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child}) : super(notifier: state);

  static AppState of(BuildContext context) => context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
