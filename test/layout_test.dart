import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_converter/l10n/app_localizations.dart';
import 'package:open_converter/main.dart';

import 'support.dart';

/// Screen sizes in logical pixels: phones and tablets, both orientations.
const _sizes = {
  'small phone': Size(320, 568),
  'phone': Size(390, 844),
  'phone landscape': Size(844, 390),
  'tablet': Size(820, 1180),
  'tablet landscape': Size(1180, 820),
};

/// Renders the converter and settings in every language at every size.
/// Text overflow and layout errors fail the test.
void main() {
  for (final locale in AppLocalizations.supportedLocales) {
    for (final MapEntry(key: name, value: size) in _sizes.entries) {
      testWidgets('${locale.toLanguageTag()} · $name', (tester) async {
        tester.view
          ..physicalSize = size
          ..devicePixelRatio = 1;
        tester.platformDispatcher.localesTestValue = [locale];
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearLocalesTestValue);

        final state = (await tester.runAsync(testState))!;
        await tester.pumpWidget(ConverterApp(state: state));
        await tester.pumpAndSettle();
        final l10n = lookupAppLocalizations(locale);
        expect(find.text(l10n.appTitle), findsOneWidget);
        expect(find.text('7'), findsOneWidget);

        // Settings has the longest strings.
        await tester.tap(find.byType(PopupMenuButton<Widget>));
        await tester.pumpAndSettle();
        await tester.tap(find.text(l10n.settings));
        await tester.pumpAndSettle();
        expect(find.text(l10n.decimalPlaces), findsOneWidget);
      });
    }
  }
}
