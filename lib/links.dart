import 'package:url_launcher/url_launcher.dart';

/// Donation page. Placeholder until the Buy Me a Coffee page exists.
// TODO: replace with the real https://buymeacoffee.com/<name> link.
final donateUrl = Uri.parse('https://buymeacoffee.com/');

/// Opens [url] in the browser. Returns false if nothing could open it.
Future<bool> openLink(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } catch (_) {
    return false;
  }
}
