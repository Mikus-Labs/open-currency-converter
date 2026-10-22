import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

/// The App Store wants tips to go through In-App Purchase, so the iOS app
/// leaves the donation link out. The web app keeps it, even on iPhones.
bool get showDonate => kIsWeb || defaultTargetPlatform != TargetPlatform.iOS;

/// Donation page.
final donateUrl = Uri.parse('https://buymeacoffee.com/zacharymikus');

/// Opens [url] in the browser. Returns false if nothing could open it.
Future<bool> openLink(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
