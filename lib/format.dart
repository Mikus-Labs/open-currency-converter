import 'dart:math' as math;

import 'package:intl/intl.dart';

import 'l10n/app_localizations.dart';

/// Formats a converted amount for display with grouping, e.g. `12,345.67`.
///
/// Values under 1 get extra decimals so small amounts (and crypto) keep at
/// least three significant digits instead of rounding to 0.
String formatAmount(double value, int decimals) {
  if (value == 0 || !value.isFinite) return '0';
  return NumberFormat(_pattern(_digitsFor(value, decimals)), 'en_US').format(value);
}

/// Like [formatAmount] but without grouping, suitable for editing or pasting.
String plainAmount(double value, int decimals) {
  if (value == 0 || !value.isFinite) return '0';
  var s = value.toStringAsFixed(_digitsFor(value, decimals));
  if (s.contains('.')) {
    s = s.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
  return s.replaceFirst('-', '−');
}

/// Adds grouping to the numbers inside a keypad expression for display.
String groupExpression(String expr) {
  return expr.replaceAllMapped(RegExp(r'\d+'), (m) {
    // Leave digits after a decimal point alone.
    if (m.start > 0 && expr[m.start - 1] == '.') return m[0]!;
    return m[0]!.replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');
  });
}

int _digitsFor(double value, int decimals) {
  final abs = value.abs();
  if (abs >= 1) return decimals;
  final leadingZeros = (-math.log(abs) / math.ln10).floor();
  return math.min(10, math.max(decimals, leadingZeros + 3));
}

String _pattern(int digits) => digits == 0 ? '#,##0' : '#,##0.${'#' * digits}';

/// Human-friendly age for use mid-sentence, e.g. "just now", "3 h ago".
String relativeAge(AppLocalizations l10n, DateTime time, DateTime now) {
  final diff = now.difference(time);
  if (diff.inMinutes < 1) return l10n.ageJustNow;
  if (diff.inHours < 1) return l10n.ageMinutes(diff.inMinutes);
  if (diff.inHours < 24) return l10n.ageHours(diff.inHours);
  if (diff.inDays < 2) return l10n.ageYesterday;
  return l10n.ageDays(diff.inDays);
}
