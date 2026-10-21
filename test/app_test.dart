import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:open_converter/app_state.dart';
import 'package:open_converter/main.dart';
import 'package:open_converter/rates.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _rates = '{"date":"2026-10-20","usd":{"usd":1,"eur":0.9,"gbp":0.75,"jpy":150,"cny":7}}';
const _names = '{"usd":"US Dollar","eur":"Euro","gbp":"British Pound","jpy":"Japanese Yen","cny":"Chinese Yuan"}';

Future<AppState> _state({bool online = true}) async {
  SharedPreferences.setMockInitialValues({});
  final client = MockClient((req) async {
    if (!online) throw http.ClientException('offline');
    return http.Response(req.url.path.endsWith('/usd.min.json') ? _rates : _names, 200);
  });
  final state = AppState(
    service: RatesService(client: client),
    prefs: await SharedPreferences.getInstance(),
  );
  await state.load();
  return state;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('loads bundled rates, then refreshes from the API', () async {
    final state = await _state();
    expect(state.fetchedAt, isNull);
    expect(state.snapshot.rates.length, greaterThan(100));
    expect(await state.refresh(), isTrue);
    expect(state.snapshot.rates['eur'], 0.9);
    expect(state.fetchedAt, isNotNull);
  });

  test('offline refresh keeps rates and reports an error', () async {
    final state = await _state(online: false);
    final before = state.snapshot;
    expect(await state.refresh(), isFalse);
    expect(state.snapshot, same(before));
  });

  test('converts, switches rows and honours own rates', () async {
    final state = await _state();
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
    final state = await _state();
    state.addCurrency('chf');
    state.toggleFavorite('chf');
    state.setDecimals(4);
    final restored = AppState(prefs: await SharedPreferences.getInstance());
    await restored.load();
    expect(restored.selected.last, 'chf');
    expect(restored.favorites, {'chf'});
    expect(restored.decimals, 4);
  });

  test('reorder keeps the active currency active', () async {
    final state = await _state();
    state.setActive(2); // gbp
    state.reorder(2, 0);
    expect(state.selected.first, 'gbp');
    expect(state.activeCode, 'gbp');
  });

  test('removing the active row carries the amount over', () async {
    final state = await _state();
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
    final state = (await tester.runAsync(_state))!;
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
}
