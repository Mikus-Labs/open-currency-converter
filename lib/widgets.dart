import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(size * 0.3),
      ),
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

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
