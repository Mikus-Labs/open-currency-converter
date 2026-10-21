import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension AppLocalizationsContext on BuildContext {
  /// The UI strings for the current locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
