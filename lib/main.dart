import 'package:flutter/material.dart';

import 'app_state.dart';
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
          title: 'Converter',
          debugShowCheckedModeBanner: false,
          themeMode: widget.state.themeMode,
          theme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.light),
          darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark),
          home: const ConverterScreen(),
        ),
      ),
    );
  }
}
