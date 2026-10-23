# TODO

## Status

- **Repo:** public at
  [Mikus-Labs/open-currency-converter](https://github.com/Mikus-Labs/open-currency-converter),
  MIT licence. `main` and release tags are protected; changes go in through
  pull requests. See [CONTRIBUTING.md](CONTRIBUTING.md) and
  [SECURITY.md](SECURITY.md).
- **Name:** Open Currency Converter. Home-screen label "Converter".
- **App ID:** `co.mikuslabs.openconverter` (Android and iOS). It can never
  change after the first store upload.
- **Privacy policy:** <https://mikus-labs.github.io/open-currency-converter/PRIVACY>
- **Support email:** dev@mikuslabs.co. **Donations:** <https://ko-fi.com/mikuslabs>
  (hidden in the iOS app).
- **Test builds** (debug-signed GitHub pre-releases): v0.1.0 (broken, hangs
  on launch), v0.2.0 (old app ID), **v0.3.0** (current: new app ID, rating
  prompt, Ko-fi, split APKs).
- **Open pull requests:** none.

## Before publishing on Google Play

Google Play first, then the App Store (next section). Each item is marked
**you** (accounts, decisions, anything needing your identity or a device) or
**Claude** (code, docs, listing drafts). The Play account (section 3) and the
14-day closed test (section 6) are the slow parts, so start them early.

### 1. Make sure the Android build works

- [x] **Release workflow builds Android without iOS**, one APK per
      processor type plus the Play bundle, in about 6 minutes.
- [x] **Emulator smoke test** opens the release APK on every release and on
      every pull request that changes dependencies or `android/`. It caught
      the v0.1.0 launch hang (a plugin bug in release builds).
- [x] **Rates fallback:** jsDelivr first, then `currency-api.pages.dev`, as
      the exchange-api README asks. Tested in `test/rates_test.dart`.
- [x] **v0.3.0 test build:** the new app ID, the rating prompt and the
      Ko-fi link. Uninstall v0.2.0 first; Android sees
      the new ID as a different app.
- [ ] **You: test v0.3.0 on an Android phone** (uninstall v0.2.0 first):
  - [ ] the keypad, including `000`/`00`, `%` and long-press backspace
  - [ ] keypad vibration
  - [ ] adding, removing and reordering currencies
  - [ ] the currency picker filter (All / No crypto / Crypto only) and tags
  - [ ] own rates
  - [ ] the rates download over Wi-Fi and mobile data
  - [ ] offline start in airplane mode
  - [ ] Copy, Paste and Share
  - [ ] the Ko-fi link (v0.3.0)
  - [ ] switching language in Settings, including Arabic right-to-left
  - [ ] dark mode
  - [ ] landscape
  - [ ] the home-screen icon on a round and a squircle launcher
  - [ ] Android 13+ per-app language under system settings
  - [ ] a tablet, if you have one (Android Studio's emulator otherwise)

### 2. Decisions

- [x] **App name, app ID, privacy policy URL, support email** (see Status).
- [ ] **You: launch languages.** Ship all 8 machine-translated languages,
      get them reviewed first, or launch in English and enable the rest
      after review (removing an ARB file and running `tool/l10n.dart`
      removes a language).
- [ ] **You: app signing key.** When creating the app in Play Console,
      either let Google hold the signing key (the default; the upload key
      can be reset if lost), or upload your own so GitHub APKs and Play
      installs can update each other (lose it and the app can never be
      updated again). Chosen once, when the app is created.

### 3. Play Console account and signing (you)

- [ ] **Create a personal developer account** at
      play.google.com/console ($25, once). Google verifies your identity
      with a government ID, which can take a few days. New accounts must
      also verify that they have an Android device, via the Play Console
      mobile app.
- [ ] **Create the upload key** and add the four `ANDROID_*` secrets. See
      [docs/RELEASING.md](docs/RELEASING.md#one-time-setup-android). Back
      up the `.jks` and its password, e.g. in a password manager.
- [ ] **Claude: keep the signing secrets in a `release` environment** that
      only `v*` tag builds can use, so no other branch or workflow can read
      them. Needs a small change to `release.yml`.
- [ ] **Create the app** in Play Console: free (a free app can never become
      paid), app, default language English (en-US).

### 4. Store listing (Claude drafts, you approve)

- [ ] **Short description** (80 characters max) and **full description**
      (4,000 max). No rankings, "best", or other apps' names. Mention the
      Ko-fi link only if you want to; Play allows it.
- [ ] **App icon, 512×512 PNG.** Resize `assets/icon/icon.png`.
- [ ] **Feature graphic, 1024×500.** Required.
- [ ] **Phone screenshots**, 2 to 8. Claude renders them from the app at
      store sizes, in light and dark.
- [ ] **7-inch and 10-inch tablet screenshots**, needed for the tablet
      listing.
- [ ] **Category: Tools.** Finance invites extra scrutiny. Add tags.
- [ ] **Contact details:** dev@mikuslabs.co; website mikuslabs.co or the
      GitHub repo.
- [ ] **Translated listings** for the launch languages (optional).

### 5. Play Console forms (you fill them in; the answers are below)

- [ ] **Privacy policy:** the URL in Status.
- [ ] **App access:** all functionality is available without special
      access.
- [ ] **Ads:** no ads.
- [ ] **Content rating (IARC questionnaire):** a utility with no
      user-generated content, chat, gambling or violence. Expect "Everyone"
      or "PEGI 3".
- [ ] **Target audience:** 18 and over, or 13 and over. Including under-13s
      brings in the Families policy for no benefit.
- [ ] **Data safety:** no data collected and none shared. Data in transit is
      encrypted (HTTPS). There's no account, so there's nothing to delete.
      This matches [PRIVACY.md](PRIVACY.md). The in-app review dialog is
      Google Play's own and doesn't change the answer.
- [ ] **Financial features declaration:** none. A currency converter
      offers no banking, loans, payments or trading.
- [ ] **Government app, health, news:** no to each.
- [ ] **Countries:** all.

### 6. Testing tracks (required for new personal accounts)

- [ ] **Internal testing:** tag `v1.0.0`, upload the `.aab` from the draft
      GitHub Release, and add yourself. Install it from Play and repeat the
      device checks from section 1.
- [ ] **Closed testing: at least 12 testers opted in for 14 days in a
      row.** New personal accounts can't publish to production without this.
      Start recruiting friends and family now; each needs a Google account
      and must keep the app installed. Push at least one update during the
      14 days, since Google asks about tester feedback.
- [ ] **Apply for production access** in Play Console (a short
      questionnaire about the test). Review usually takes a few days.

### 7. Launch

- [ ] **Production release**, with a staged rollout (e.g. 20% first).
- [ ] **Watch Android vitals** in Play Console for crashes and ANRs (app
      not responding). The app has no crash reporting of its own, by
      design.
- [ ] **GitHub Release:** publish the draft with the signed APKs.

### Before launch if possible (Claude)

- [ ] **Locale-aware numbers.** German, French, Spanish and Russian users
      see `1,234.56` instead of their own format. This is the most visible
      gap in the translations; see Localisation below.
- [ ] **Localised dates** (same section).

## Before publishing on the App Store

Can start any time; nothing here waits on Google Play. Unlike Play, Apple has
no 14-day testing requirement, but every release goes through App Review.
CI runs on macOS for free now that the repo is public.

### 1. Account (you)

- [ ] **You: enrol in the Apple Developer Program** ($99 a year) at
      developer.apple.com/programs. Decide first:
  - **Individual:** quick (a day or two). The store shows your own name as
    the seller.
  - **Organisation (Mikus Labs):** the store shows "Mikus Labs", but it
    needs a registered legal entity, a free D-U-N-S number (can take a
    couple of weeks) and a website on the organisation's domain
    (mikuslabs.co).
- [ ] **You: check the name is free** in App Store Connect when creating
      the app (next section). App Store names must be unique; if "Open
      Currency Converter" is taken, a subtitle-style variant works (the
      30-character subtitle is separate).

### 2. Make the iOS app store-ready (Claude)

- [x] **Privacy manifest** (`ios/Runner/PrivacyInfo.xcprivacy`): required by
      Apple since May 2024. Declare no tracking, no collected data, and the
      reason for using `UserDefaults` (settings storage, reason `CA92.1`).
- [x] **Dark launch screen:** the iOS launch screen is plain white, a flash
      in dark mode. Use the system background colour so it follows the
      theme.
- [x] **Unsigned iOS build in CI** (*Run workflow* → `all`): builds on
      Xcode (17.9 MB app, no warnings beyond the missing signing).
- [x] **Already done:** export compliance (`ITSAppUsesNonExemptEncryption`
      is false), icon without transparency, all iPad orientations, the
      language list in `Info.plist`, Ko-fi link hidden (guideline 3.1.1),
      rating prompt uses Apple's own dialog (Apple limits it to 3 times a
      year anyway).

### 3. Test on an iPhone (you, with Claude)

- [ ] **Run it on your own iPhone** from Xcode with a free Apple ID (no paid
      account needed): plug it in, `flutter run --release`, trust the
      developer profile under Settings → General → VPN & Device Management.
- [ ] **iOS-specific checks**, on top of the Android list:
  - [ ] the "Allow Paste" prompt when pasting
  - [ ] haptics on the keypad
  - [ ] the share sheet
  - [ ] per-app language under Settings → Converter → Language
  - [ ] larger text sizes (Settings → Accessibility → Display & Text Size)
  - [ ] iPad: Split View and Slide Over, both orientations
  - [ ] no Ko-fi entry in Settings

### 4. Signing (you; steps in docs/RELEASING.md)

- [ ] **App ID** `co.mikuslabs.openconverter` (Certificates, IDs & Profiles).
- [ ] **Apple Distribution certificate** exported as `.p12`.
- [ ] **App Store provisioning profile** for the App ID.
- [ ] **The three `IOS_*` secrets**, in the same `release` environment as the
      Android ones. See
      [docs/RELEASING.md](docs/RELEASING.md#one-time-setup-ios).
- [ ] **Claude (optional): upload to TestFlight from CI** with an App Store
      Connect API key, instead of dragging the `.ipa` into Transporter.

### 5. App Store Connect record (you fill it in; Claude drafts the text)

- [ ] **New app:** iOS, name, primary language English (U.S.), bundle ID,
      SKU (e.g. `open-currency-converter`).
- [ ] **Subtitle** (30 characters), **description**, **keywords** (100
      characters, comma-separated, no repeats of the name),
      **promotional text**.
- [ ] **Category:** Utilities (secondary: Finance, optional).
- [ ] **Support URL** (required): the GitHub repo or a page on mikuslabs.co.
      **Privacy policy URL:** see Status.
- [ ] **Screenshots:** 6.9-inch iPhone (1320×2868) and 13-inch iPad
      (2064×2752), both required since the app runs on iPad. Claude renders
      them.
- [ ] **Age rating questionnaire:** none of the content applies; expect 4+.
- [ ] **App Privacy:** "Data Not Collected".
- [ ] **Pricing:** free, all countries.
- [ ] **Copyright:** "2026 Mikus Labs" (or your name if enrolled as an
      individual).

### 6. TestFlight and review

- [ ] **TestFlight internal testing:** tag a release, upload the `.ipa`,
      install it with the TestFlight app. No review needed for internal
      testers.
- [ ] **Submit for review**, with review notes: no login, works offline,
      rates come from a public API. Expect a day or two.
- [ ] **Watch for guideline 4.3 (spam):** Apple sometimes rejects simple
      converters as duplicates of many similar apps. If that happens, reply
      pointing out what's different: open source, no ads or tracking,
      offline use, a calculator on every row, own rates, 300+ currencies
      including crypto, 8 languages.

### 7. Launch

- [ ] **Release with phased release** (spread over 7 days; can be paused).
- [ ] **Watch crashes** in App Store Connect → TestFlight / Xcode
      Organizer.

## Features

Ideas and requests. Tick them off as they ship.

- [x] **Rating prompt:** after 5 minutes of total use, ask once (ever)
      for a store rating with the Play / App Store in-app review dialog. Use
      only counts while the app is on screen, and it waits for a pause in
      typing. The stores decide whether the dialog actually appears, so some
      users never see it.

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
