import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../app_state.dart';
import '../expression.dart' as calc;
import '../format.dart';
import '../l10n/l10n.dart';
import '../widgets.dart';
import 'currencies_screen.dart';
import 'currency_picker.dart';
import 'own_rates_screen.dart';
import 'rates_screen.dart';
import 'settings_screen.dart';

class ConverterScreen extends StatelessWidget {
  const ConverterScreen({super.key});

  Future<void> _refresh(BuildContext context, AppState state) async {
    if (!await state.refresh() && context.mounted) {
      showMessage(context, context.l10n.offlineError(state.snapshot.date));
    }
  }

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final updated = state.fetchedAt == null
        ? l10n.ratesOffline(state.snapshot.date)
        : l10n.ratesUpdated(relativeAge(l10n, state.fetchedAt!, DateTime.now()), state.snapshot.date);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.appTitle),
            Text(updated, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.refreshRates,
            onPressed: state.loading ? null : () => _refresh(context, state),
            icon: state.loading
                ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: l10n.share,
            icon: const Icon(Icons.share_outlined),
            onPressed: () => SharePlus.instance.share(ShareParams(text: state.shareText())),
          ),
          PopupMenuButton<Widget>(
            onSelected: (screen) => _open(context, screen),
            itemBuilder: (_) => [
              PopupMenuItem(value: const CurrenciesScreen(), child: Text(l10n.currencies)),
              PopupMenuItem(value: const RatesScreen(), child: Text(l10n.exchangeRates)),
              PopupMenuItem(value: const OwnRatesScreen(), child: Text(l10n.ownRates)),
              PopupMenuItem(value: const SettingsScreen(), child: Text(l10n.settings)),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final currencies = Expanded(
              child: RefreshIndicator(
                onRefresh: () => _refresh(context, state),
                child: ReorderableListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  // Rows are dragged by their handle so taps and long-presses keep working.
                  buildDefaultDragHandles: false,
                  itemCount: state.selected.length,
                  onReorderItem: state.reorder,
                  itemBuilder: (context, i) => _ConverterRow(key: ValueKey(state.selected[i]), index: i),
                  footer: Padding(
                    padding: const EdgeInsets.all(8),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addCurrency),
                      onPressed: () async {
                        final code = await pickCurrency(
                          context,
                          title: l10n.addCurrency,
                          exclude: state.selected.toSet(),
                        );
                        if (code != null) state.addCurrency(code);
                      },
                    ),
                  ),
                ),
              ),
            );
            final keypad = Keypad(onKey: state.press);

            // Landscape: currencies beside a full-height keypad.
            if (constraints.maxWidth > constraints.maxHeight) {
              final width = (constraints.maxWidth * 0.42).clamp(280.0, 520.0);
              return Row(
                children: [
                  currencies,
                  SizedBox(width: width, child: keypad),
                ],
              );
            }
            // Portrait: keypad below, growing with the screen on tablets.
            final height = (constraints.maxHeight * 0.45).clamp(240.0, 560.0);
            return Column(
              children: [
                currencies,
                SizedBox(height: height, child: keypad),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ConverterRow extends StatelessWidget {
  const _ConverterRow({super.key, required this.index});

  final int index;

  Future<void> _showActions(BuildContext context, AppState state) async {
    final code = state.selected[index];
    final value = state.valueFor(index);
    final l10n = context.l10n;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.changeCurrency),
              onTap: () => Navigator.pop(context, 'change'),
            ),
            ListTile(
              leading: const Icon(Icons.copy),
              title: Text(l10n.copy),
              onTap: () => Navigator.pop(context, 'copy'),
            ),
            ListTile(
              leading: const Icon(Icons.content_paste),
              title: Text(l10n.paste),
              onTap: () => Navigator.pop(context, 'paste'),
            ),
            if (state.selected.length > 1)
              ListTile(
                leading: const Icon(Icons.remove_circle_outline),
                title: Text(l10n.remove),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
          ],
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'change':
        final picked = await pickCurrency(context, title: l10n.replaceCurrency(code.toUpperCase()));
        if (picked != null) state.replaceCurrency(index, picked);
      case 'copy':
        if (value != null) {
          await Clipboard.setData(ClipboardData(text: plainAmount(value, state.decimals).replaceAll('−', '-')));
          if (context.mounted) showMessage(context, l10n.copied);
        }
      case 'paste':
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        state.setActive(index);
        if (!state.paste(data?.text ?? '') && context.mounted) showMessage(context, l10n.clipboardNoNumber);
      case 'remove':
        state.removeCurrency(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final code = state.selected[index];
    final isActive = index == state.active;
    final value = state.valueFor(index);
    final l10n = context.l10n;

    final String main;
    String? sub;
    if (isActive) {
      main = state.expr.isEmpty ? '0' : groupExpression(state.expr);
      if (calc.hasOperation(state.expr)) sub = '= ${formatAmount(state.amount, state.decimals)}';
    } else {
      main = value == null ? '—' : formatAmount(value, state.decimals);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3),
      color: isActive ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerLow,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => state.setActive(index),
        onLongPress: () => _showActions(context, state),
        child: Padding(
          padding: EdgeInsets.fromLTRB(state.selected.length > 1 ? 0 : 12, 10, 4, 10),
          child: Row(
            children: [
              if (state.selected.length > 1)
                ReorderableDragStartListener(
                  index: index,
                  child: Tooltip(
                    message: l10n.dragToReorder,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: Icon(Icons.drag_indicator, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ),
              CurrencyBadge(code),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(code.toUpperCase(), style: theme.textTheme.titleMedium),
                      if (state.hasOwnRate(code))
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Tooltip(
                            message: l10n.ownRate,
                            child: Icon(Icons.edit_note, size: 18, color: theme.colorScheme.tertiary),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 120,
                    child: Text(
                      state.nameOf(code),
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        main,
                        maxLines: 1,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    if (sub != null)
                      Text(sub, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              if (state.selected.length > 1)
                IconButton(
                  tooltip: l10n.removeCurrency(code.toUpperCase()),
                  visualDensity: VisualDensity.compact,
                  icon: Icon(Icons.close, size: 20, color: theme.colorScheme.onSurfaceVariant),
                  onPressed: () => state.removeCurrency(index),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Calculator keypad that fills the space it is given. Long-press backspace
/// to clear.
class Keypad extends StatelessWidget {
  const Keypad({super.key, required this.onKey});

  final ValueChanged<String> onKey;

  // A cell with several space-separated keys is split into half-width keys.
  static const _rows = [
    ['C', '%', '⌫', '÷'],
    ['7', '8', '9', '×'],
    ['4', '5', '6', '−'],
    ['1', '2', '3', '+'],
    ['000 00', '0', '.', '='],
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    // Keypads keep the 7 8 9 order in right-to-left languages too.
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
        color: scheme.surfaceContainer,
        child: Column(
          children: [
            for (final row in _rows)
              Expanded(
                child: Row(
                  children: [
                    for (final cell in row)
                      Expanded(
                        child: Row(
                          children: [
                            for (final key in cell.split(' '))
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(3),
                                  child: _Key(
                                    label: key,
                                    onTap: () {
                                      // 00 and 000 type their zeros one at a time.
                                      if (RegExp(r'^00+$').hasMatch(key)) {
                                        for (var i = 0; i < key.length; i++) {
                                          onKey('0');
                                        }
                                      } else {
                                        onKey(key);
                                      }
                                    },
                                    onLongPress: key == '⌫' ? () => onKey('C') : null,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Key extends StatelessWidget {
  const _Key({required this.label, required this.onTap, this.onLongPress});

  final String label;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isOperator = calc.operators.contains(label) || label == '=';
    final isFunction = label == 'C' || label == '%' || label == '⌫';
    final background = label == '='
        ? scheme.primary
        : isOperator
        ? scheme.secondaryContainer
        : isFunction
        ? scheme.surfaceContainerHighest
        : scheme.surface;
    final foreground = label == '='
        ? scheme.onPrimary
        : isOperator
        ? scheme.onSecondaryContainer
        : scheme.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        onLongPress: onLongPress,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Labels scale with the key: larger on tablets, smaller in phone landscape.
            final size = (constraints.maxHeight * 0.4).clamp(16.0, 34.0);
            return Center(
              child: label == '⌫'
                  ? Icon(Icons.backspace_outlined, size: size, color: foreground, semanticLabel: context.l10n.backspace)
                  // Half-width keys (000, 00) shrink their label to fit.
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          label,
                          style: TextStyle(fontSize: size, color: foreground, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
