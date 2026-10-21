import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_converter/app_state.dart';
import 'package:open_converter/currency_kind.dart';
import 'package:open_converter/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled rates, then refreshes from the API', () async {
    final state = await testState();
    expect(state.fetchedAt, isNull);
    expect(state.snapshot.rates.length, greaterThan(100));
    expect(await state.refresh(), isTrue);
    expect(state.snapshot.rates['eur'], 0.9);
    expect(state.fetchedAt, isNotNull);
  });

  test('offline refresh keeps rates and reports an error', () async {
    final state = await testState(online: false);
    final before = state.snapshot;
    expect(await state.refresh(), isFalse);
    expect(state.snapshot, same(before));
  });

  test('converts, switches rows and honours own rates', () async {
    final state = await testState();
    await state.refresh();
    state.press('C');
    for (final k in ['1', '0', '0']) {
      state.press(k);
    }
    expect(state.valueFor(1), closeTo(90, 1e-9)); // USD -> EUR
    expect(state.valueFor(3), closeTo(15000, 1e-9)); // USD -> JPY

    state.setActive(1); // EUR row now holds 90
    expect(state.expr, '90');
    state.press('9'); // replaces the prefilled value
    expect(state.expr, '9');
    expect(state.valueFor(0), closeTo(10, 1e-9));

    state.setOwnRate('jpy', const OwnRate(base: 'eur', value: 200));
    expect(state.valueFor(3), closeTo(1800, 1e-9));
    state.setUseOwnRates(false);
    expect(state.valueFor(3), closeTo(1500, 1e-9));
  });

  test('state persists across restarts', () async {
    final state = await testState();
    state.addCurrency('chf');
    state.toggleFavorite('chf');
    state.setDecimals(4);
    state.setZeroKeys(ZeroKeys.tripleZero);
    state.setCurrencyFilter(CurrencyFilter.noCrypto);
    state.setLocale(const Locale('de'));
    final restored = AppState(prefs: await SharedPreferences.getInstance());
    await restored.load();
    expect(restored.selected.last, 'chf');
    expect(restored.favorites, {'chf'});
    expect(restored.decimals, 4);
    expect(restored.zeroKeys, ZeroKeys.tripleZero);
    expect(restored.currencyFilter, CurrencyFilter.noCrypto);
    expect(restored.locale, const Locale('de'));
  });

  test('reorder keeps the active currency active', () async {
    final state = await testState();
    state.setActive(2); // gbp
    state.reorder(2, 0);
    expect(state.selected.first, 'gbp');
    expect(state.activeCode, 'gbp');
  });

  test('removing the active row carries the amount over', () async {
    final state = await testState();
    await state.refresh();
    state.press('C');
    state.press('1');
    state.press('0'); // 10 USD on row 0
    state.removeCurrency(0);
    expect(state.activeCode, 'eur');
    expect(state.expr, '9');
    state.setActive(2); // jpy
    state.removeCurrency(0); // removing a row above the active one
    expect(state.activeCode, 'jpy');
  });

  testWidgets('keypad drives the converter', (tester) async {
    // Asset and prefs loading is real I/O, which must run outside fake async.
    final state = (await tester.runAsync(testState))!;
    await tester.pumpWidget(ConverterApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Converter'), findsOneWidget);
    await tester.tap(find.text('C'));
    await tester.tap(find.text('5'));
    await tester.tap(find.text('+'));
    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text('5+5'), findsOneWidget);
    expect(find.text('= 10'), findsOneWidget);
    // EUR row shows 10 USD at the mocked 0.9 rate.
    expect(find.text('9'), findsWidgets);

    // The split zero keys type three and two zeros.
    await tester.tap(find.text('C'));
    await tester.tap(find.text('1'));
    await tester.tap(find.text('000'));
    await tester.tap(find.text('00'));
    await tester.pump();
    expect(state.expr, '100000');
    expect(tester.getCenter(find.text('000')).dx, lessThan(tester.getCenter(find.text('00')).dx));

    // Dragging a row's handle reorders it in place.
    expect(find.byIcon(Icons.drag_indicator), findsNWidgets(5));
    final gesture = await tester.startGesture(tester.getCenter(find.byIcon(Icons.drag_indicator).first));
    await tester.pump();
    for (var i = 0; i < 10; i++) {
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump(const Duration(milliseconds: 16));
    }
    await gesture.up();
    await tester.pumpAndSettle();
    expect(state.selected.first, isNot('usd'));
    expect(state.selected, contains('usd'));
    expect(state.activeCode, 'usd');

    // Each row has its own remove button.
    expect(find.byTooltip('Remove GBP'), findsOneWidget);
    await tester.tap(find.byTooltip('Remove GBP'));
    await tester.pump();
    expect(state.selected, isNot(contains('gbp')));
    expect(find.text('GBP'), findsNothing);

    await tester.tap(find.byType(PopupMenuButton<Widget>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Exchange rates'));
    await tester.pumpAndSettle();
    expect(find.text('1 USD'), findsOneWidget);
  });

  testWidgets('settings change the zero keys and the language', (tester) async {
    final state = (await tester.runAsync(testState))!;
    await tester.pumpWidget(ConverterApp(state: state));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(PopupMenuButton<Widget>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('00').last);
    await tester.pumpAndSettle();
    expect(state.zeroKeys, ZeroKeys.doubleZero);

    await tester.tap(find.text('System default'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Deutsch').last);
    await tester.pumpAndSettle();
    expect(state.locale, const Locale('de'));
    expect(find.text('Einstellungen'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Spendier mir einen Kaffee'), 200);

    Navigator.of(tester.element(find.text('Einstellungen'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('00'), findsOneWidget);
    expect(find.text('000'), findsNothing);
    state.setZeroKeys(ZeroKeys.tripleZero);
    await tester.pump();
    expect(find.text('000'), findsOneWidget);
    expect(find.text('00'), findsNothing);
  });

  testWidgets('the iOS app has no donation link', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    final state = (await tester.runAsync(testState))!;
    await tester.pumpWidget(ConverterApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<Widget>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.textContaining('No ads, no accounts'), 200);
    expect(find.text('Buy me a coffee'), findsNothing);
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('currency picker labels and filters crypto', (tester) async {
    // Offline, so the bundled rates (with crypto) aren't replaced by the mock.
    final state = (await tester.runAsync(() => testState(online: false)))!;
    await tester.pumpWidget(ConverterApp(state: state));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add currency'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(SearchBar), 'bitcoin');
    await tester.pump();
    expect(find.text('BTC'), findsWidgets);
    expect(find.text('Crypto'), findsWidgets);

    await tester.tap(find.text('No crypto'));
    await tester.pumpAndSettle();
    expect(find.text('BTC'), findsNothing);

    await tester.enterText(find.byType(SearchBar), 'bbd');
    await tester.pump();
    expect(find.text('BBD'), findsWidgets);
    expect(find.text('Fiat'), findsOneWidget);

    await tester.tap(find.text('Crypto only'));
    await tester.pumpAndSettle();
    expect(find.text('BBD'), findsNothing);
    await tester.tap(find.text('No crypto'));
    await tester.pumpAndSettle();
    expect(state.currencyFilter, CurrencyFilter.noCrypto);
  });
}
