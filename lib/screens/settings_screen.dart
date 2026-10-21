import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Decimal places'),
            subtitle: const Text('Amounts below 1 always keep 3 significant digits'),
            trailing: DropdownButton<int>(
              value: state.decimals,
              onChanged: (v) => state.setDecimals(v!),
              items: [for (var i = 0; i <= 6; i++) DropdownMenuItem(value: i, child: Text('$i'))],
            ),
          ),
          SwitchListTile(title: const Text('Keypad vibration'), value: state.haptics, onChanged: state.setHaptics),
          ListTile(
            title: const Text('Theme'),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(value: ThemeMode.system, label: Text('System')),
                  ButtonSegment(value: ThemeMode.light, label: Text('Light')),
                  ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                ],
                selected: {state.themeMode},
                onSelectionChanged: (s) => state.setThemeMode(s.first),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Exchange rates'),
            subtitle: Text(
              state.fetchedAt == null
                  ? 'Built-in offline rates of ${state.snapshot.date}'
                  : 'Rates of ${state.snapshot.date}, downloaded ${relativeAge(state.fetchedAt!, DateTime.now()).toLowerCase()}',
            ),
            trailing: state.loading
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : IconButton(
                    tooltip: 'Refresh now',
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      final error = await state.refresh();
                      if (context.mounted) showMessage(context, error ?? 'Rates updated');
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Text(
              'Rates come from the free, open fawazahmed0 currency-api (CC0) and are updated daily. '
              'They are reference rates for information only, not trading quotes.\n\n'
              'No ads, no accounts, no tracking.',
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
