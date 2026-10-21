# Converter

An ad-free, offline-first currency converter for Android, iOS and the web.
No ads, no subscriptions, no accounts, no tracking.

## Features

- Calculator keypad with `+ − × ÷ %` (e.g. `200+10%` = 220) on any row
- Any number of currencies; tap a row to convert from it, long-press for
  change / copy / paste / remove
- 300+ currencies including major crypto, with search and favorites
- Exchange-rates table against any base currency
- Own rates: override a market rate with your bank's or exchange office's
- Works offline: last downloaded rates are cached and a snapshot ships with
  the app; rates refresh automatically when older than 6 hours
- Share the current conversion, decimal places, light/dark theme, haptics

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

Code layout:

| File | Purpose |
|---|---|
| `lib/expression.dart` | Keypad input rules and expression evaluation |
| `lib/format.dart` | Amount formatting and relative times |
| `lib/rates.dart` | Rates snapshot model and API client |
| `lib/app_state.dart` | App state, conversion, persistence |
| `lib/screens/` | Converter, currencies, rates, own rates, settings, picker |
