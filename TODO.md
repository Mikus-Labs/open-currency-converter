# TODO

## Localisation

Localisation is set up, but only English exists so far. The app it replaces
shipped 24 languages, so this is the main gap for users outside
English-speaking countries.

- [x] **Set up Flutter localisation** with `lib/l10n/app_en.arb` as the
      template. See [docs/LOCALISATION.md](docs/LOCALISATION.md).
- [x] **Move UI strings into ARB,** with ICU plurals for relative times.
- [x] **Platform metadata:** `tool/l10n.dart` keeps `CFBundleLocalizations`
      and Android's `locales_config.xml` in sync with the ARB files.
- [ ] **Locale-aware numbers:** `formatAmount` hard-codes `en_US`, so grouping
      and decimal separators are always `1,234.56`. Format with the device
      locale. Pasting and parsing must still accept both `,` and `.`.
- [ ] **Keypad decimal key:** show the locale's decimal separator, while the
      expression keeps `.` internally.
- [ ] **Currency names:** the names come in English from the rates API. Use
      localised names from CLDR data (for example a generated table per
      language) and fall back to the API name. Search in the currency picker
      should match both the localised and the English name, plus the code.
- [ ] **Localised dates:** the rates date is shown as `2026-10-20`; format it
      with `DateFormat.yMMMd(l10n.localeName)`.
- [ ] **Home-screen name:** the launcher name ("Converter") comes from
      `AndroidManifest.xml` and `Info.plist`, not the ARB files. Localise it
      with Android `values-<locale>/strings.xml` and iOS
      `InfoPlist.strings` if the translated name should differ.
- [ ] **Right-to-left:** check layouts in Arabic, Hebrew and Persian. Number
      fields should stay left-to-right.
- [ ] **Tests:** a widget test that pumps the app in a non-English locale and
      checks number formatting.
- [ ] **Store listings:** translate the store descriptions and screenshots
      for each language shipped.
- [ ] **Add the first languages:** for example es, de, fr, pt_BR, ru, tr,
      zh_Hans, ja, ar, hi, using the prompt in docs/LOCALISATION.md. Have a
      native speaker review each before release.
