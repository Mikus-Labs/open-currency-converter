# TODO

## Before publishing on Google Play

Google Play first, the App Store later. Each item is marked with who does
it: **you** (accounts, decisions, anything needing your identity or a
device) or **Claude** (code, docs, listing drafts). Roughly in order; the
Play account (section 3) has waiting periods, so start it in parallel with
section 1.

### 1. Make sure the Android build works

- [x] **Claude: let the release workflow build Android without iOS.** Tag
      builds stop with an error when the iOS signing secrets are missing, and
      the GitHub Release waits for the iOS job. Make the iOS job skip itself
      when there are no iOS secrets, and add an "Android only" option to
      manual runs so they don't use macOS minutes.
- [x] **Build the Android release in CI.** The first build (v0.1.0) hung on
      the launch screen because of a plugin bug in release builds; fixed in
      v0.2.0. An emulator smoke test now checks every release and
      dependency update.
- [ ] **You: install the v0.2.0 APK on an Android phone and test:**
  - [ ] the keypad, including `000`/`00`, `%` and long-press backspace
  - [ ] keypad vibration
  - [ ] adding, removing and reordering currencies
  - [ ] own rates
  - [ ] the rates download over Wi-Fi and mobile data
  - [ ] offline start in airplane mode
  - [ ] Copy, Paste and Share
  - [ ] the Buy me a coffee link
  - [ ] switching language, including Arabic right-to-left
  - [ ] dark mode
  - [ ] landscape
  - [ ] the home-screen icon on a round and a squircle launcher
  - [ ] Android 13+ per-app language under system settings
  - [ ] a tablet, if you have one (Android Studio's emulator otherwise)

### 2. Decisions

- [ ] **You: app name.** The Play title has a 30-character limit and needs
      to be findable. "Converter" alone is generic and crowded. The name
      appears in the Android label (`android:label`), `appTitle` in every
      ARB file, the iOS display name and the README. Claude updates them
      once you choose.
- [ ] **You: confirm the app ID** `io.github.zacharymikus.openconverter`. It
      can never change after the first upload to Play.
- [ ] **You: privacy policy URL.** Play needs a public URL. Either make the
      repo public (`.../blob/main/PRIVACY.md`), or publish it with GitHub
      Pages (a paid plan for a private repo). The policy's contact link is
      the Issues page, which only works on a public repo; Claude can switch
      it to an email if the repo stays private.
- [ ] **You: support email.** Play shows a contact email publicly on the
      listing. Consider a separate address rather than your personal one.
- [ ] **You: launch languages.** Ship all 8 machine-translated languages,
      get them reviewed first, or launch in English and enable the rest
      after review (removing an ARB file and running `tool/l10n.dart`
      removes a language).

### 3. Play Console account and signing (you)

- [ ] **Create a personal developer account** at
      play.google.com/console ($25, once). Google verifies your identity
      with a government ID, which can take a few days. New accounts must
      also verify that they have an Android device, via the Play Console
      mobile app.
- [ ] **Create the upload key** and add the four `ANDROID_*` secrets. See
      [docs/RELEASING.md](docs/RELEASING.md#one-time-setup-android). Back
      up the `.jks` and its password, e.g. in a password manager.
- [ ] **Create the app** in Play Console: free (a free app can never become
      paid), app, default language English (en-US). Keep *Play App
      Signing* on.

### 4. Store listing (Claude drafts, you approve)

- [ ] **Short description** (80 characters max) and **full description**
      (4,000 max). No mention of rankings, "best", or other apps. Mention the
      Buy Me a Coffee link only if you want to; Play allows it.
- [ ] **App icon, 512×512 PNG.** Resize `assets/icon/icon.png`.
- [ ] **Feature graphic, 1024×500.** Required.
- [ ] **Phone screenshots**, 2 to 8. Claude can render them from the app at
      store sizes, in light and dark.
- [ ] **7-inch and 10-inch tablet screenshots**, needed for the tablet
      listing.
- [ ] **Category: Tools.** Finance invites extra scrutiny. Add tags.
- [ ] **Translated listings** for the launch languages (optional).

### 5. Play Console forms (you fill them in; the answers are below)

- [ ] **Privacy policy:** the URL from section 2.
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
      This matches [PRIVACY.md](PRIVACY.md).
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
- [ ] **GitHub Release:** publish the draft. The APK on it is only
      downloadable by others if the repo is public.

### Before launch if possible (Claude)

- [ ] **Locale-aware numbers.** German, French, Spanish and Russian users
      see `1,234.56` instead of their own format. This is the most visible
      gap in the translations; see Localisation below.
- [ ] **Localised dates** (same section).

### After Google Play

- [ ] **App Store:** Apple Developer Program, signing secrets, iPad
      screenshots and App Privacy. See
      [docs/RELEASING.md](docs/RELEASING.md#one-time-setup-ios). The
      donation link is already hidden on iOS.

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
