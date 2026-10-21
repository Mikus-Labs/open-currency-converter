import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../l10n/l10n.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.decimalPlaces),
            subtitle: Text(l10n.decimalPlacesSubtitle),
            trailing: DropdownButton<int>(
              value: state.decimals,
              onChanged: (v) => state.setDecimals(v!),
              items: [for (var i = 0; i <= 6; i++) DropdownMenuItem(value: i, child: Text('$i'))],
            ),
          ),
          SwitchListTile(title: Text(l10n.keypadVibration), value: state.haptics, onChanged: state.setHaptics),
          ListTile(
            title: Text(l10n.theme),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SegmentedButton<ThemeMode>(
                segments: [
                  ButtonSegment(value: ThemeMode.system, label: Text(l10n.themeSystem)),
                  ButtonSegment(value: ThemeMode.light, label: Text(l10n.themeLight)),
                  ButtonSegment(value: ThemeMode.dark, label: Text(l10n.themeDark)),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => state.setThemeMode(s.first),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: Text(l10n.exchangeRates),
            subtitle: Text(
              state.fetchedAt == null
                  ? l10n.ratesBuiltIn(state.snapshot.date)
                  : l10n.ratesDownloaded(state.snapshot.date, relativeAge(l10n, state.fetchedAt!, DateTime.now())),
            ),
            trailing: state.loading
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    tooltip: l10n.refreshNow,
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      final ok = await state.refresh();
                      if (context.mounted) {
                        showMessage(context, ok ? l10n.ratesRefreshed : l10n.offlineError(state.snapshot.date));
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Text(
              l10n.aboutRates,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
