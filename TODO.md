# TODO

## Localisation

The app is English-only. The app it replaces shipped 24 languages, so this is
the main gap for users outside English-speaking countries.

- [ ] **Set up Flutter localisation:** add `flutter_localizations`, set
      `generate: true` in `pubspec.yaml`, add `l10n.yaml` and
      `lib/l10n/app_en.arb`, and wire `localizationsDelegates` and
      `supportedLocales` into `MaterialApp` in `lib/main.dart`.
- [ ] **Move UI strings into ARB:** about 70 strings across `lib/screens/` and
      `lib/widgets.dart`. Use ICU plurals for counts and `relativeAge` in
      `lib/format.dart` ("N min ago", "Yesterday", ...).
- [ ] **Locale-aware numbers:** `formatAmount` hard-codes `en_US`, so grouping
      and decimal separators are always `1,234.56`. Format with the device
      locale. Pasting and parsing must still accept both `,` and `.`.
- [ ] **Keypad decimal key:** show the locale's decimal separator, while the
      expression keeps `.` internally.
- [ ] **Currency names:** the names come in English from the rates API. Use
      localised names from CLDR data (for example a generated table per
      language) and fall back to the API name. Search in the currency picker
      should match both the localised and the English name, plus the code.
- [ ] **Platform metadata:** add `CFBundleLocalizations` to
      `ios/Runner/Info.plist`; on Android add `locales_config.xml` and
      `android:localeConfig` so the per-app language setting lists the app's
      languages. Localise the app display name if needed.
- [ ] **Right-to-left:** check layouts in Arabic, Hebrew and Persian. Number
      fields should stay left-to-right.
- [ ] **Tests:** a widget test that pumps the app in a non-English locale and
      checks number formatting.
- [ ] **Store listings:** translate the store descriptions and screenshots
      for each language shipped.
- [ ] **Pick the first languages:** for example es, de, fr, pt-BR, ru, tr,
      zh-Hans, ja, ar, hi. Decide how translations are produced and reviewed.
