import 'package:flutter/material.dart';

import '../app_state.dart';
import '../format.dart';
import '../l10n/l10n.dart';
import '../widgets.dart';
import 'currency_picker.dart';

/// Table of every rate against a chosen base currency.
class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  String? _base;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final base = _base ?? state.activeCode;
    final q = _query.trim().toLowerCase();

    // Shown currencies first, then everything else alphabetically.
    final codes =
        state.snapshot.rates.keys
            .where((c) => c != base)
            .where((c) => q.isEmpty || c.contains(q) || state.nameOf(c).toLowerCase().contains(q))
            .toList()
          ..sort((a, b) {
            final sa = state.selected.indexOf(a), sb = state.selected.indexOf(b);
            if ((sa == -1) != (sb == -1)) return sa == -1 ? 1 : -1;
            if (sa != -1) return sa.compareTo(sb);
            return a.compareTo(b);
          });

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.exchangeRates),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              hintText: l10n.search,
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CurrencyBadge(base),
            title: Text('1 ${base.toUpperCase()}'),
            subtitle: Text(l10n.ratesOf(state.nameOf(base), state.snapshot.date)),
            trailing: const Icon(Icons.swap_vert),
            onTap: () async {
              final code = await pickCurrency(context, title: l10n.baseCurrency);
              if (code != null) setState(() => _base = code);
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: codes.length,
              itemBuilder: (context, i) {
                final code = codes[i];
                final rate = state.convert(1, base, code);
                final inverse = state.convert(1, code, base);
                return ListTile(
                  leading: CurrencyBadge(code, size: 36),
                  title: Text(code.toUpperCase()),
                  subtitle: Text(state.nameOf(code), overflow: TextOverflow.ellipsis),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(rate == null ? '—' : formatAmount(rate, 4), style: theme.textTheme.titleMedium),
                      if (inverse != null)
                        Text(
                          l10n.rateEquation(code.toUpperCase(), formatAmount(inverse, 4), base.toUpperCase()),
                          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
