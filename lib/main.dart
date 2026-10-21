import 'package:flutter/material.dart';

import 'app_state.dart';
import 'l10n/l10n.dart';
import 'screens/converter_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load();
  runApp(ConverterApp(state: state));
}

class ConverterApp extends StatefulWidget {
  const ConverterApp({super.key, required this.state});

  final AppState state;

  @override
  State<ConverterApp> createState() => _ConverterAppState();
}

class _ConverterAppState extends State<ConverterApp> {
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    widget.state.refreshIfStale();
    _lifecycle = AppLifecycleListener(onResume: widget.state.refreshIfStale);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF00897B);
    return AppScope(
      state: widget.state,
      child: ListenableBuilder(
        listenable: widget.state,
        builder: (context, _) => MaterialApp(
          onGenerateTitle: (context) => context.l10n.appTitle,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          themeMode: widget.state.themeMode,
          theme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.light),
          darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark),
          builder: (context, child) {
            // Tablets get larger text so rows don't look phone-sized next to the keypad.
            final media = MediaQuery.of(context);
            if (media.size.shortestSide < 600) return child!;
            final scale = media.textScaler.scale(14) / 14 * 1.2;
            return MediaQuery(
              data: media.copyWith(textScaler: TextScaler.linear(scale)),
              child: child!,
            );
          },
          home: const ConverterScreen(),
        ),
      ),
    );
  }
}
