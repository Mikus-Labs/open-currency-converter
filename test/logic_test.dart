import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_converter/expression.dart';
import 'package:open_converter/format.dart';
import 'package:open_converter/l10n/app_localizations.dart';
import 'package:open_converter/rates.dart';

void main() {
  group('evaluate', () {
    test('respects precedence', () {
      expect(evaluate('2+3×4'), 14);
      expect(evaluate('10−4÷2'), 8);
    });
    test('percent of running total and plain percent', () {
      expect(evaluate('200+10%'), closeTo(220, 1e-9));
      expect(evaluate('200−25%'), closeTo(150, 1e-9));
      expect(evaluate('50×10%'), closeTo(5, 1e-9));
      expect(evaluate('5%'), closeTo(0.05, 1e-9));
    });
    test('handles partial and unary input', () {
      expect(evaluate('12+'), 12);
      expect(evaluate('−5+2'), -3);
      expect(evaluate('3×−2'), -6);
      expect(evaluate('.5'), 0.5);
      expect(evaluate('7.'), 7);
    });
    test('rejects bad input', () {
      expect(evaluate(''), isNull);
      expect(evaluate('1÷0'), isNull);
      expect(evaluate('1.2.3'), isNull);
      expect(evaluate('abc'), isNull);
    });
  });

  group('applyKey', () {
    String type(String keys, [String start = '']) => keys.split('').fold(start, (e, k) => applyKey(e, k));

    test('builds expressions', () {
      expect(type('12+3'), '12+3');
      expect(type('1+×2'), '1×2');
      expect(type('×−2', '3'), '3×−2');
      expect(type('..5'), '0.5');
      expect(type('007'), '7');
      expect(type('5%%'), '5%');
      expect(type('5%3'), '5%');
      expect(type('12⌫'), '1');
      expect(type('12C'), '');
    });
  });

  group('format', () {
    test('formatAmount groups and adapts decimals', () {
      expect(formatAmount(1234567.891, 2), '1,234,567.89');
      expect(formatAmount(12, 2), '12');
      expect(formatAmount(0.000013195, 2), '0.0000132');
      expect(formatAmount(0.5, 2), '0.5');
    });
    test('plainAmount trims zeros and uses display minus', () {
      expect(plainAmount(92.10, 2), '92.1');
      expect(plainAmount(-3, 2), '−3');
    });
    test('groupExpression leaves decimals alone', () {
      expect(groupExpression('1234567.12345+1000'), '1,234,567.12345+1,000');
    });
    test('relativeAge', () {
      final now = DateTime(2026, 10, 21, 12);
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(relativeAge(l10n, now, now), 'just now');
      expect(relativeAge(l10n, now.subtract(const Duration(minutes: 1)), now), '1 min ago');
      expect(relativeAge(l10n, now.subtract(const Duration(hours: 3)), now), '3 h ago');
      expect(relativeAge(l10n, now.subtract(const Duration(hours: 30)), now), 'yesterday');
      expect(relativeAge(l10n, now.subtract(const Duration(days: 4)), now), '4 d ago');
    });
  });

  test('RatesService.parse drops unusable entries', () {
    final s = RatesService.parse(
      '{"date":"2026-10-20","usd":{"usd":1,"eur":0.92,"zzz":0.5,"bad":0}}',
      '{"usd":"US Dollar","eur":"Euro","bad":"Bad"}',
    );
    expect(s.date, '2026-10-20');
    expect(s.rates, {'usd': 1.0, 'eur': 0.92});
    expect(s.names['eur'], 'Euro');
  });
}
