# Contributing

Thanks for helping. Bug reports, translations and fixes are all welcome.

## Reporting a bug or asking for a feature

Open an [issue](../../issues/new/choose). For bugs, say which device and
Android or iOS version you're on, what you did and what happened.
Screenshots help.

## Translations

The app's text lives in `lib/l10n/app_<language>.arb`, one file per language,
with English (`app_en.arb`) as the source. Each message in `app_en.arb` has a
description explaining where it appears.

- **Fixing a translation:** edit the language's ARB file and open a pull
  request. If you'd rather not touch git, open a *Translation* issue instead.
- **Adding a language:** copy `app_en.arb` to `app_<code>.arb` (for example
  `app_it.arb`), set `"@@locale"`, translate every message, drop the
  `@`-entries, and run `dart run tool/l10n.dart`.

Keep `{placeholders}` exactly as they are, and keep the plural forms (`=0`,
`=1`, `few`, `many`, `other`…) that your language needs.
[docs/LOCALISATION.md](docs/LOCALISATION.md) has the full workflow.

## Code

You need [Flutter](https://docs.flutter.dev/get-started/install) (the version
is pinned in `pubspec.yaml`). Android builds need Android Studio; iOS builds
need Xcode.

```sh
flutter pub get
flutter run
```

Before opening a pull request:

```sh
dart format lib test tool
flutter analyze
flutter test
dart run tool/l10n.dart   # if you changed an ARB file
```

CI runs the same checks on every pull request, and an Android emulator test
on changes to dependencies or `android/`.

Keep changes focused, and match the style of the surrounding code. The app
has no ads, accounts, analytics or tracking, and contributions must keep it
that way. New network requests need a good reason and an update to
[PRIVACY.md](PRIVACY.md).

By contributing you agree that your contribution is licensed under the
[MIT licence](LICENSE).
