# Releasing

Two GitHub Actions workflows live in `.github/workflows/`:

| Workflow | Runs on | Does |
|---|---|---|
| `ci.yml` | every push to `main` and every PR | format check, `flutter analyze`, `flutter test` |
| `release.yml` | tags `vX.Y.Z`, or manually | tests, then a signed Android **AAB + APK** and an App Store **IPA**, attached to a **draft** GitHub Release |
| `android-smoke.yml` | PRs that change `pubspec.lock` or `android/`, each release, or manually | installs a release APK on an Android emulator and checks the app opens; the log and a screenshot are saved as an artifact |

App ID on both platforms: `co.mikuslabs.openconverter`.

## Cutting a release

Release tags (`v*`) are protected: once pushed they can't be moved or
deleted, so check the commit before tagging. A bad release gets a new
version number.

```sh
git tag v1.0.0
git push origin v1.0.0
```

- The tag sets the version name (`1.0.0`); the workflow run number is the
  build number, so it always increases, which both stores require.
- When the run finishes, open **Releases** on GitHub, check the draft and its
  files, then upload them to the stores:
  - **Google Play:** Play Console → your app → *Test and release* → create a
    release on a track (start with *Internal testing*) → upload the `.aab`.
  - **App Store:** upload the `.ipa` with Apple's
    [Transporter](https://apps.apple.com/app/transporter/id1450874784) app
    (sign in, drag the file in, *Deliver*). It appears in App Store Connect →
    TestFlight after processing, and from there you submit it for review.
- The `.apk` files are for sideloading or stores that take APKs; Play wants
  the `.aab`. There's one APK per processor type, each a third the size of a
  universal APK: `arm64-v8a` for almost every phone from the last decade,
  `armeabi-v7a` for older 32-bit phones, `x86_64` for emulators and some
  Chromebooks.

**Test run:** *Actions → Release → Run workflow* (or
`gh workflow run release.yml`) builds without creating a release. It builds
Android only unless you pick `all`, since iOS runs on macOS. Without signing
secrets it makes a debug-signed APK and an unsigned iOS build, which is enough
to check the pipeline before store accounts exist.

Tag builds need the Android secrets. They skip iOS until the iOS secrets are
set, so Google Play can go first.

## One-time setup: Android

The app uses **our own app signing key**, and Google holds a copy for Play
App Signing. Play installs and the GitHub APKs carry the same signature, so
people can move between them without uninstalling. The same key signs the
`.aab` we upload, so it's the upload key too.

The key lives in 1Password and, for CI, in the `release` **environment**
(Settings → Environments), which only `v*` tag builds can use. Other
branches, pull requests and manual runs can't read it.

If the key is ever lost, Play keeps working because Google has a copy. But
GitHub APKs would need a new key, so people who installed one would have to
uninstall. Keep the backup.

1. **Create the key** on your Mac. `keytool` comes with Android Studio's
   Java. It asks for a password: generate a long one in 1Password.

   ```sh
   export PATH="/Applications/Android Studio.app/Contents/jbr/Contents/Home/bin:$PATH"
   keytool -genkeypair -v -keystore ~/Desktop/open-currency-converter.jks \
     -storetype PKCS12 -alias openconverter -keyalg RSA -keysize 4096 \
     -validity 10000 -dname "CN=Mikus Labs, O=Mikus Labs"
   keytool -list -v -keystore ~/Desktop/open-currency-converter.jks | grep SHA256
   ```

   The name in `-dname` is public: it's in every APK's certificate.
   `-validity 10000` is about 27 years; Play needs a key valid past 2033.

2. **Back it up:** a new 1Password item with the `.jks` file attached, its
   password, the alias `openconverter` and the SHA-256 fingerprint.

3. **Add it to the `release` environment.** `gh secret set` prompts for the
   password without echoing it. PKCS12 keystores have one password, so the
   store and key passwords are the same:

   ```sh
   R=Mikus-Labs/open-currency-converter
   base64 -i ~/Desktop/open-currency-converter.jks | gh secret set ANDROID_KEYSTORE_BASE64 --env release -R $R
   gh secret set ANDROID_KEYSTORE_PASSWORD --env release -R $R
   gh secret set ANDROID_KEY_PASSWORD --env release -R $R
   gh secret set ANDROID_KEY_ALIAS --env release -R $R --body openconverter
   gh variable set ANDROID_CERT_SHA256 --env release -R $R --body "AB:CD:…"   # from step 1
   ```

   With `ANDROID_CERT_SHA256` set, a release fails if the APKs are signed
   with any other key. The fingerprint isn't secret; it's printed on every
   build.

4. **Upload the key to Play App Signing**, before uploading any `.aab`. If
   you upload a bundle first and accept the default, Google generates its
   own key and the APKs won't match. In Play Console, open the app →
   *Test and release* → *App integrity* → *App signing* (or the signing
   prompt on your first release). Choose to **export and upload a key from
   a Java keystore**, download the PEPK tool and encryption key it offers,
   run the `java -jar pepk.jar …` command it shows against the `.jks` above,
   and upload the resulting `.zip`. Skip the optional separate upload key:
   it would sit in the same `release` environment, so it adds nothing.

5. **Delete `~/Desktop/open-currency-converter.jks`** once 1Password,
   GitHub and Play have it.

For a local signed build, save the `.jks` from 1Password, set
`ANDROID_KEYSTORE_PATH` to it plus `ANDROID_KEYSTORE_PASSWORD`,
`ANDROID_KEY_ALIAS` and `ANDROID_KEY_PASSWORD`, then run
`flutter build appbundle`. Without them, release builds use debug keys.

The `release` environment was created with:

```sh
gh api -X PUT repos/Mikus-Labs/open-currency-converter/environments/release \
  -F 'deployment_branch_policy[protected_branches]=false' \
  -F 'deployment_branch_policy[custom_branch_policies]=true'
gh api -X POST repos/Mikus-Labs/open-currency-converter/environments/release/deployment-branch-policies \
  -f name='v*' -f type=tag
```

## One-time setup: iOS

Needs the [Apple Developer Program](https://developer.apple.com/programs/)
($99/year) and a Mac with Xcode for the certificate.

1. **App ID:** developer.apple.com → Certificates, IDs & Profiles →
   Identifiers → **+** → App IDs → App → bundle ID
   `co.mikuslabs.openconverter` (explicit). No extra capabilities
   are needed.
2. **Distribution certificate:** Xcode → Settings → Accounts → your team →
   *Manage Certificates* → **+** → *Apple Distribution*. Then in Keychain
   Access, find "Apple Distribution: …" under *My Certificates*, right-click →
   *Export* as `.p12` with a password.
3. **Provisioning profile:** Profiles → **+** → *App Store Connect* → pick the
   App ID and the certificate → download the `.mobileprovision`.
4. **App Store Connect:** My Apps → **+** → New App, with the same bundle ID.
5. **Secrets**, in the `release` environment like the Android ones:

   ```sh
   R=Mikus-Labs/open-currency-converter
   base64 -i dist.p12 | gh secret set IOS_DISTRIBUTION_CERTIFICATE_BASE64 --env release -R $R
   gh secret set IOS_DISTRIBUTION_CERTIFICATE_PASSWORD --env release -R $R
   base64 -i Converter_App_Store.mobileprovision | gh secret set IOS_PROVISIONING_PROFILE_BASE64 --env release -R $R
   ```

The workflow reads the team ID and profile name from the profile itself and
checks that it matches the bundle ID. The certificate and profile expire after
a year; renew them and update the two base64 secrets.

## Before the first store submission

- **Donation link on iOS:** App Store guideline 3.1.1 asks for tips to the
  developer to go through In-App Purchase, so `showDonate` in `lib/links.dart`
  hides the Settings entry in the iOS app. Don't mention donations in the App
  Store listing either. Google Play doesn't require Play Billing for donations.
- **Privacy policy URL:** both stores require one. The policy is
  [`PRIVACY.md`](../PRIVACY.md), published with GitHub Pages at
  <https://mikus-labs.github.io/open-currency-converter/PRIVACY>.
- **Privacy forms:** the app collects no data and has no ads or tracking, so
  Play *Data safety* is "No data collected" and App Store *App Privacy* is
  "Data Not Collected". Export compliance is pre-answered:
  `ITSAppUsesNonExemptEncryption` is `false`, since the app only uses HTTPS.
- **Screenshots and store listing text** for each store. The app supports
  tablets in both orientations, so the App Store also needs iPad screenshots
  (13-inch), and Play needs tablet screenshots to be listed as
  tablet-optimised.
