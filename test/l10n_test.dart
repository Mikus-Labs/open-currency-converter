import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:open_converter/l10n/app_localizations.dart';

Map<String, dynamic> _readArb(File file) => jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;

/// Message keys, without the `@` metadata entries.
Set<String> _messages(Map<String, dynamic> arb) => arb.keys.where((k) => !k.startsWith('@')).toSet();

void main() {
  final template = _readArb(File('lib/l10n/app_en.arb'));
  final translations = Directory('lib/l10n')
      .listSync()
      .whereType<File>()
      .where((f) => RegExp(r'app_\w+\.arb$').hasMatch(f.path) && !f.path.endsWith('app_en.arb'))
      .toList();

  for (final file in translations) {
    final name = file.uri.pathSegments.last;

    group(name, () {
      final arb = _readArb(file);

      test('declares its locale', () {
        final locale = RegExp(r'app_(\w+)\.arb$').firstMatch(name)!.group(1);
        expect(arb['@@locale'], locale);
      });

      test('has exactly the template messages', () {
        expect(_messages(template).difference(_messages(arb)), isEmpty, reason: 'missing translations');
        expect(_messages(arb).difference(_messages(template)), isEmpty, reason: 'keys not in app_en.arb');
      });

      test('keeps every placeholder', () {
        for (final key in _messages(template)) {
          final placeholders = (template['@$key']?['placeholders'] as Map<String, dynamic>?)?.keys ?? const [];
          for (final p in placeholders) {
            expect(arb[key], contains('{$p'), reason: '$key must keep {$p}');
          }
        }
      });
    });
  }

  test('every ARB file is a supported locale', () {
    final codes = AppLocalizations.supportedLocales.map((l) => l.toLanguageTag().replaceAll('-', '_')).toSet();
    expect(codes, contains('en'));
    expect(codes.length, translations.length + 1, reason: 'run: dart run tool/l10n.dart');
    expect(lookupAppLocalizations(const Locale('en')).appTitle, isNotEmpty);
  });
}
