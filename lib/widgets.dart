import 'package:flutter/material.dart';

import 'app_state.dart';
import 'currency_kind.dart';
import 'l10n/l10n.dart';

/// Rounded tile showing a currency code, tinted per currency so rows are
/// easy to tell apart without bundling flag images.
class CurrencyBadge extends StatelessWidget {
  const CurrencyBadge(this.code, {super.key, this.size = 40});

  final String code;
  final double size;

  static final _schemes = <(String, Brightness), ColorScheme>{};

  static ColorScheme _schemeFor(String code, Brightness brightness) {
    return _schemes.putIfAbsent((code, brightness), () {
      final hue = code.codeUnits.fold(7, (h, c) => (h * 31 + c) % 360);
      return ColorScheme.fromSeed(
        seedColor: HSLColor.fromAHSL(1, hue.toDouble(), 0.6, 0.5).toColor(),
        brightness: brightness,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = _schemeFor(code, Theme.of(context).brightness);
    final label = code.toUpperCase();
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(size * 0.3)),
      child: Text(
        label.length > 4 ? label.substring(0, 4) : label,
        style: TextStyle(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.w700,
          fontSize: size * (label.length > 3 ? 0.24 : 0.3),
        ),
      ),
    );
  }
}

/// A currency code followed by a small fiat / crypto / metal tag.
class CurrencyTitle extends StatelessWidget {
  const CurrencyTitle(this.code, {super.key});

  final String code;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final kind = kindOf(code);
    final (label, background, foreground) = switch (kind) {
      CurrencyKind.fiat => (
        l10n.kindFiat,
        theme.colorScheme.secondaryContainer,
        theme.colorScheme.onSecondaryContainer,
      ),
      CurrencyKind.crypto => (
        l10n.kindCrypto,
        theme.colorScheme.tertiaryContainer,
        theme.colorScheme.onTertiaryContainer,
      ),
      CurrencyKind.metal => (l10n.kindMetal, theme.colorScheme.surfaceContainerHighest, theme.colorScheme.onSurface),
    };
    return Row(
      children: [
        Text(code.toUpperCase()),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(6)),
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(color: foreground),
            ),
          ),
        ),
      ],
    );
  }
}

/// All / no crypto / crypto only, shared by the long currency lists.
class CurrencyFilterBar extends StatelessWidget {
  const CurrencyFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    return SegmentedButton<CurrencyFilter>(
      showSelectedIcon: false,
      style: const ButtonStyle(visualDensity: VisualDensity.compact),
      segments: [
        for (final (value, label) in [
          (CurrencyFilter.all, l10n.filterAll),
          (CurrencyFilter.noCrypto, l10n.filterNoCrypto),
          (CurrencyFilter.cryptoOnly, l10n.filterCryptoOnly),
        ])
          // Long translations shrink rather than wrap on small phones.
          ButtonSegment(
            value: value,
            label: FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
          ),
      ],
      selected: {state.currencyFilter},
      onSelectionChanged: (s) => state.setCurrencyFilter(s.first),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
