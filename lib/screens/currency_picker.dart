import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets.dart';

/// Opens a searchable currency list and returns the chosen code.
Future<String?> pickCurrency(BuildContext context, {String title = 'Choose currency', Set<String> exclude = const {}}) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (_) => CurrencyPickerScreen(title: title, exclude: exclude)),
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
    final q = _query.trim().toLowerCase();
    final codes = state.snapshot.rates.keys
        .where((c) => !widget.exclude.contains(c))
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
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: SearchBar(
              autoFocus: true,
              hintText: 'Search code or name',
              leading: const Icon(Icons.search),
              elevation: const WidgetStatePropertyAll(0),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
        ),
      ),
      body: codes.isEmpty
          ? const Center(child: Text('Not found'))
          : ListView.builder(
              itemCount: codes.length,
              itemBuilder: (context, i) {
                final code = codes[i];
                final isFavorite = state.favorites.contains(code);
                return ListTile(
                  leading: CurrencyBadge(code),
                  title: Text(code.toUpperCase()),
                  subtitle: Text(state.nameOf(code)),
                  trailing: IconButton(
                    tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
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
