import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../l10n/l10n.dart';
import '../widgets.dart';
import 'currency_picker.dart';

/// Manual rate overrides, e.g. the rate at a local exchange office.
class OwnRatesScreen extends StatelessWidget {
  const OwnRatesScreen({super.key});

  Future<void> _add(BuildContext context, AppState state) async {
    final code = await pickCurrency(context, title: context.l10n.currencyToOverride);
    if (code == null || !context.mounted) return;
    await _edit(context, state, code);
  }

  Future<void> _edit(BuildContext context, AppState state, String code) async {
    final rate = await showDialog<OwnRate>(
      context: context,
      builder: (_) => _OwnRateDialog(state: state, code: code, initial: state.ownRates[code]),
    );
    if (rate != null) state.setOwnRate(code, rate);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final codes = state.ownRates.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ownRates)),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: Text(l10n.add),
        onPressed: () => _add(context, state),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 88),
        children: [
          SwitchListTile(
            title: Text(l10n.useOwnRates),
            subtitle: Text(l10n.useOwnRatesSubtitle),
            value: state.useOwnRates,
            onChanged: state.setUseOwnRates,
          ),
          const Divider(),
          if (codes.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                l10n.ownRatesEmpty,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          for (final code in codes)
            Builder(
              builder: (context) {
                final own = state.ownRates[code]!;
                final market = state.marketRate(code);
                final marketBase = state.marketRate(own.base);
                final marketValue = market != null && marketBase != null ? market / marketBase : null;
                return ListTile(
                  leading: CurrencyBadge(code),
                  title: Text(
                    l10n.rateEquation(own.base.toUpperCase(), formatAmount(own.value, 4), code.toUpperCase()),
                  ),
                  subtitle: marketValue == null ? null : Text(l10n.marketRate(formatAmount(marketValue, 4))),
                  onTap: () => _edit(context, state, code),
                  trailing: IconButton(
                    tooltip: l10n.delete,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => state.removeOwnRate(code),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _OwnRateDialog extends StatefulWidget {
  const _OwnRateDialog({required this.state, required this.code, this.initial});

  final AppState state;
  final String code;
  final OwnRate? initial;

  @override
  State<_OwnRateDialog> createState() => _OwnRateDialogState();
}

class _OwnRateDialogState extends State<_OwnRateDialog> {
  late String _base = widget.initial?.base ?? (widget.code == 'usd' ? 'eur' : 'usd');
  late final _controller = TextEditingController(text: _initialText());

  String _initialText() {
    final initial = widget.initial;
    if (initial != null) return plainAmount(initial.value, 6);
    final market = widget.state.marketRate(widget.code), base = widget.state.marketRate(_base);
    return market != null && base != null ? plainAmount(market / base, 4).replaceAll('−', '-') : '';
  }

  double? get _value {
    final v = double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    return v != null && v > 0 ? v : null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final code = widget.code.toUpperCase();
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.ownRateFor(code)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('1 '),
              TextButton(
                onPressed: () async {
                  final picked = await pickCurrency(context, title: l10n.ratePerOneOf, exclude: {widget.code});
                  if (picked != null) setState(() => _base = picked);
                },
                child: Text(_base.toUpperCase()),
              ),
              const Text(' ='),
            ],
          ),
          TextField(
            controller: _controller,
            autofocus: true,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(suffixText: code, border: const OutlineInputBorder()),
            onChanged: (_) => setState(() {}),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          onPressed: _value == null ? null : () => Navigator.pop(context, OwnRate(base: _base, value: _value!)),
          child: Text(l10n.save),
        ),
      ],
    );
  }
}
