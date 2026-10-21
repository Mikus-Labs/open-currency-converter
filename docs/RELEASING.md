# Releasing

Two GitHub Actions workflows live in `.github/workflows/`:

| Workflow | Runs on | Does |
|---|---|---|
| `ci.yml` | every push to `main` and every PR | format check, `flutter analyze`, `flutter test` |
| `release.yml` | tags `vX.Y.Z`, or manually | tests, then a signed Android **AAB + APK** and an App Store **IPA**, attached to a **draft** GitHub Release |

App ID on both platforms: `io.github.zacharymikus.openconverter`.

## Cutting a release

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
- The `.apk` is for sideloading or stores that take APKs. Play wants the `.aab`.

**Test run:** *Actions → Release → Run workflow* builds without creating a
release. Without signing secrets it makes a debug-signed APK and an unsigned
iOS build, which is enough to check the pipeline before store accounts exist.
Tag builds always require the secrets.

## One-time setup: Android

1. **Create an upload key** and keep it backed up, e.g. in a password manager:

   ```sh
   keytool -genkeypair -v -keystore ~/open-converter-upload.jks \
     -alias upload -keyalg RSA -keysize 4096 -validity 10000
   ```

2. **Add the secrets** (Settings → Secrets and variables → Actions, or `gh`):

   ```sh
   base64 -i ~/open-converter-upload.jks | gh secret set ANDROID_KEYSTORE_BASE64
   gh secret set ANDROID_KEYSTORE_PASSWORD   # keystore password
   gh secret set ANDROID_KEY_ALIAS --body upload
   gh secret set ANDROID_KEY_PASSWORD        # key password (same as keystore if you only set one)
   ```

3. **Play Console** ($25 one-time): create the app and keep *Play App Signing*
   on, which is the default. Google then holds the real signing key and this
   one is only your *upload* key, so it can be reset if lost.

For a local signed build, export the same variables, with
`ANDROID_KEYSTORE_PATH=~/open-converter-upload.jks`, and run
`flutter build appbundle`. Without them, release builds use debug keys.

## One-time setup: iOS

Needs the [Apple Developer Program](https://developer.apple.com/programs/)
($99/year) and a Mac with Xcode for the certificate.

1. **App ID:** developer.apple.com → Certificates, IDs & Profiles →
   Identifiers → **+** → App IDs → App → bundle ID
   `io.github.zacharymikus.openconverter` (explicit). No extra capabilities
   are needed.
2. **Distribution certificate:** Xcode → Settings → Accounts → your team →
   *Manage Certificates* → **+** → *Apple Distribution*. Then in Keychain
   Access, find "Apple Distribution: …" under *My Certificates*, right-click →
   *Export* as `.p12` with a password.
3. **Provisioning profile:** Profiles → **+** → *App Store Connect* → pick the
   App ID and the certificate → download the `.mobileprovision`.
4. **App Store Connect:** My Apps → **+** → New App, with the same bundle ID.
5. **Secrets:**

   ```sh
   base64 -i dist.p12 | gh secret set IOS_DISTRIBUTION_CERTIFICATE_BASE64
   gh secret set IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
   base64 -i Converter_App_Store.mobileprovision | gh secret set IOS_PROVISIONING_PROFILE_BASE64
   ```

The workflow reads the team ID and profile name from the profile itself and
checks that it matches the bundle ID. The certificate and profile expire after
a year; renew them and update the two base64 secrets.

## Before the first store submission

- **App icon:** still the default Flutter icon. Replace
  `android/app/src/main/res/mipmap-*` and
  `ios/Runner/Assets.xcassets/AppIcon.appiconset`, or use `flutter_launcher_icons`.
- **Privacy policy URL:** both stores require one, even for apps that collect
  nothing.
- **Privacy forms:** the app collects no data and has no ads or tracking, so
  Play *Data safety* is "No data collected" and App Store *App Privacy* is
  "Data Not Collected". Export compliance is pre-answered:
  `ITSAppUsesNonExemptEncryption` is `false`, since the app only uses HTTPS.
- **Screenshots and store listing text** for each store.
