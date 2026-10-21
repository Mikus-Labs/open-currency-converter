# Converter

An ad-free, offline-first currency converter for Android, iOS and the web.
No ads, no subscriptions, no accounts, no tracking.

## Features

- Calculator keypad with `+ − × ÷ %` (e.g. `200+10%` = 220) on any row
- Any number of currencies; tap a row to convert from it, long-press for
  change / copy / paste / remove
- 300+ currencies including major crypto, with search and favorites; each is
  tagged fiat, crypto or metal, and lists can hide or show only crypto
- Exchange-rates table against any base currency
- Own rates: override a market rate with your bank's or exchange office's
- Works offline: last downloaded rates are cached and a snapshot ships with
  the app; rates refresh automatically when older than 6 hours
- Share the current conversion, decimal places, light/dark theme, haptics,
  `000`/`00` keypad keys
- Phones and tablets, portrait and landscape
- English, Arabic, Chinese, French, German, Russian, Spanish and Thai,
  following the device or picked in Settings

## Exchange rates

Daily rates come from [fawazahmed0/exchange-api](https://github.com/fawazahmed0/exchange-api)
(CC0, no API key), via the jsDelivr CDN with the Cloudflare Pages mirror as
fallback. `assets/rates_fallback.json` is the bundled offline snapshot; to
regenerate it, fetch `currencies/usd.min.json` and `currencies.min.json` and
keep entries that have both a rate and a name (see `RatesService.parse`).

## Development

```sh
flutter pub get
flutter test
flutter run            # pick a device or emulator
flutter build web      # static site in build/web
flutter build apk      # needs the Android SDK (Android Studio)
flutter build ios      # needs Xcode
```

CI runs format, analyze and tests on every push. Store builds (signed AAB,
APK and IPA) come from pushing a `vX.Y.Z` tag; see
[docs/RELEASING.md](docs/RELEASING.md) for the one-time signing setup.

Code layout:

| File | Purpose |
|---|---|
| `lib/expression.dart` | Keypad input rules and expression evaluation |
| `lib/format.dart` | Amount formatting and relative times |
| `lib/rates.dart` | Rates snapshot model and API client |
| `lib/app_state.dart` | App state, conversion, persistence |
| `lib/screens/` | Converter, currencies, rates, own rates, settings, picker |

The app icon is drawn in code by `assets/icon/draw.swift`. To change it, edit
the script, then run `swift assets/icon/draw.swift assets/icon/icon.png` and
`dart run flutter_launcher_icons` to regenerate the platform icons.

UI text lives in `lib/l10n/app_en.arb`; adding a language is one translated
file plus `dart run tool/l10n.dart`. See [docs/LOCALISATION.md](docs/LOCALISATION.md).

Planned work is in [TODO.md](TODO.md).

## Support the project

Converter is free, with no ads and no subscriptions. If it's useful to you,
you can [buy me a coffee](https://buymeacoffee.com/) <!-- TODO: real link -->.
The Android and web apps link here from Settings; the iOS app doesn't, because
the App Store only allows tips through In-App Purchase.

## Privacy and licence

The app collects no data; see [PRIVACY.md](PRIVACY.md). The code is under the
[MIT licence](LICENSE). Exchange rates come from
[fawazahmed0/exchange-api](https://github.com/fawazahmed0/exchange-api) (CC0).
