# Localisation

All UI text lives in one file, **`lib/l10n/app_en.arb`**: the English
template. Every message has a `@description` that tells a translator where it
appears and what its `{placeholders}` hold. Each other language is a
translated copy of that file named `lib/l10n/app_<locale>.arb`.

The app picks the device's language when a translation exists, and English
otherwise. On Android 13+ and iOS, people can also choose a language for the
app alone in the system settings.

## Adding a language

1. **Translate the template** into `lib/l10n/app_<locale>.arb`, for example
   with the prompt below. Locale names use underscores: `de`, `pt_BR`,
   `zh_Hans`. The file's `@@locale` must match its name.
2. **Register it:**

   ```sh
   dart run tool/l10n.dart
   ```

   This regenerates the Dart code in `lib/l10n/` and adds the language to
   `ios/Runner/Info.plist` and Android's `res/xml/locales_config.xml`.
3. **Check it:** `flutter test`. `test/l10n_test.dart` fails if the file is
   missing a message, has keys the template doesn't, or dropped a
   `{placeholder}`. `test/layout_test.dart` renders the app in the new
   language on phones and tablets and fails if any text overflows.
4. Commit the ARB file together with the files the script changed. CI reruns
   the script and fails if anything is out of date.

Removing a language is the reverse: delete its ARB file and run the script.

## Adding or changing a string

1. Add the message to `app_en.arb` with a `@key` entry holding a
   `description` (required) and any `placeholders`.
2. Run `dart run tool/l10n.dart`, then use it in code as
   `context.l10n.key` (import `lib/l10n/l10n.dart`).
3. Every existing translation now fails the test until it has the new key.
   Translate just the missing keys with the second prompt below.

## Translation prompt

Give an LLM the contents of `app_en.arb` with this prompt, replacing
`LANGUAGE` and `LOCALE`:

```text
Translate this Flutter ARB file from English into LANGUAGE for a currency
converter app. Output only the new ARB file, as valid JSON.

Rules:
- Set "@@locale" to "LOCALE". Keep every message key exactly as it is.
- Output only "@@locale" and the message keys. Leave out every "@"-prefixed
  metadata entry, but read each one's "description" for context.
- Keep {placeholders} unchanged and in a natural position for LANGUAGE.
- Keep ICU plural syntax ({count, plural, ...}) and use the plural
  categories LANGUAGE needs (one, few, many, other, ...). Always include
  "other".
- Keep "fawazahmed0 currency-api", "CC0" and currency codes untranslated.
- Keep strings short: they appear on buttons, tooltips and in narrow
  subtitles on a phone. Use the conventional UI terms of iOS and Android
  in LANGUAGE (e.g. their words for Copy, Paste, Settings).
- Use the informal or formal register that apps in LANGUAGE usually use.
```

To update an existing translation after new strings were added:

```text
Here is the English template app_en.arb and the existing LANGUAGE file
app_LOCALE.arb. Add translations for the keys that are missing from
app_LOCALE.arb, following the same rules [paste the rules above], and remove
keys that are no longer in the template. Output the complete updated
app_LOCALE.arb.
```

Machine translations should be checked by a native speaker before release.

## Not localised yet

Numbers always use `1,234.56` formatting, currency names are English, and the
rates date is shown as `2026-10-20`. See [TODO.md](../TODO.md).
