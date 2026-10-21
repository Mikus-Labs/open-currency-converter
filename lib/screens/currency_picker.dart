import 'package:flutter/material.dart';

import '../app_state.dart';
import '../currency_kind.dart';
import '../l10n/l10n.dart';
import '../widgets.dart';

/// Opens a searchable currency list and returns the chosen code.
Future<String?> pickCurrency(BuildContext context, {String? title, Set<String> exclude = const {}}) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => CurrencyPickerScreen(title: title ?? context.l10n.chooseCurrency, exclude: exclude),
    ),
  );
}

class CurrencyPickerScreen extends StatefulWidget {
  const CurrencyPickerScreen({super.key, required this.title, this.exclude = const {}});

  final String title;
  final Set<String> exclude;

  @override
  State<CurrencyPickerScreen> createState() => _CurrencyPickerScreenState();
}

class _CurrencyPickerScreenState extends State<CurrencyPickerScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    final q = _query.trim().toLowerCase();
    final codes =
        state.snapshot.rates.keys
            .where((c) => !widget.exclude.contains(c))
            .where(state.currencyFilter.matches)
            .where((c) => q.isEmpty || c.contains(q) || state.nameOf(c).toLowerCase().contains(q))
            .toList()
          ..sort((a, b) {
            // Favorites first, then exact code matches, then alphabetical.
            final fa = state.favorites.contains(a), fb = state.favorites.contains(b);
            if (fa != fb) return fa ? -1 : 1;
            if (q.isNotEmpty && (a == q) != (b == q)) return a == q ? -1 : 1;
            return a.compareTo(b);
          });

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(112),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                SearchBar(
                  autoFocus: true,
                  hintText: l10n.searchCodeOrName,
                  leading: const Icon(Icons.search),
                  elevation: const WidgetStatePropertyAll(0),
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 8),
                const SizedBox(width: double.infinity, child: CurrencyFilterBar()),
              ],
            ),
          ),
        ),
      ),
      body: codes.isEmpty
          ? Center(child: Text(l10n.notFound))
          : ListView.builder(
              itemCount: codes.length,
              itemBuilder: (context, i) {
                final code = codes[i];
                final isFavorite = state.favorites.contains(code);
                return ListTile(
                  leading: CurrencyBadge(code),
                  title: CurrencyTitle(code),
                  subtitle: Text(state.nameOf(code)),
                  trailing: IconButton(
                    tooltip: isFavorite ? l10n.removeFromFavorites : l10n.addToFavorites,
                    icon: Icon(isFavorite ? Icons.star : Icons.star_border),
                    color: isFavorite ? Theme.of(context).colorScheme.primary : null,
                    onPressed: () => state.toggleFavorite(code),
                  ),
                  onTap: () => Navigator.of(context).pop(code),
                );
              },
            ),
    );
  }
}
