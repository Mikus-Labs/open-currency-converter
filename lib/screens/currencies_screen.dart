import 'package:flutter/material.dart';

import '../app_state.dart';
import '../widgets.dart';
import 'currency_picker.dart';

/// Reorder, add and remove the currencies shown on the converter.
class CurrenciesScreen extends StatelessWidget {
  const CurrenciesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Currencies')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add'),
        onPressed: () async {
          final code = await pickCurrency(context, title: 'Add currency', exclude: state.selected.toSet());
          if (code != null) state.addCurrency(code);
        },
      ),
      body: ReorderableListView.builder(
        padding: const EdgeInsets.only(bottom: 88),
        itemCount: state.selected.length,
        onReorderItem: state.reorder,
        itemBuilder: (context, i) {
          final code = state.selected[i];
          return ListTile(
            key: ValueKey(code),
            leading: CurrencyBadge(code),
            title: Text(code.toUpperCase()),
            subtitle: Text(state.nameOf(code)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Remove',
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: state.selected.length > 1 ? () => state.removeCurrency(i) : null,
                ),
                ReorderableDragStartListener(index: i, child: const Icon(Icons.drag_handle)),
              ],
            ),
          );
        },
      ),
    );
  }
}
