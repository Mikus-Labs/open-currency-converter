# TODO

## Localisation

The app ships in English, Arabic, Chinese (Simplified), French, German,
Russian, Spanish and Thai. The translations are machine-made and need review.

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
- [ ] **Right-to-left:** Arabic mirrors correctly and the keypad stays
      left-to-right. Check on a device that amounts and expressions such as
      `5+5` read naturally, and recheck when adding Hebrew or Persian.
- [x] **Tests:** `test/layout_test.dart` renders the app in every language
      at phone and tablet sizes in both orientations, failing on overflow.
- [ ] **Store listings:** translate the store descriptions and screenshots
      for each language shipped.
- [ ] **Review translations:** de, ru, fr, es, th, ar and zh were machine
      translated. Have a native speaker check each before release, and add
      Traditional Chinese (`zh_Hant`) if needed; it currently falls back to
      Simplified.
