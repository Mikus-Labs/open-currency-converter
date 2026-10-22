import 'package:flutter_test/flutter_test.dart';
import 'package:open_converter/app_state.dart';
import 'package:open_converter/review_prompt.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('asks once, after enough use, never while typing', () async {
    final state = await testState();
    var requests = 0;
    var now = DateTime.now();
    final prompt = ReviewPrompt(
      state,
      after: const Duration(seconds: 3),
      request: () async => requests++,
      now: () => now,
    );

    prompt.tick();
    prompt.tick();
    expect(requests, 0);

    // Enough use, but a key was just pressed: wait.
    state.press('1');
    now = state.lastInteraction!;
    prompt.tick();
    expect(requests, 0);

    now = now.add(const Duration(seconds: 5));
    prompt.tick();
    expect(requests, 1);
    expect(state.reviewRequested, isTrue);

    prompt.tick();
    prompt.tick();
    expect(requests, 1);

    // Never again, even after a restart.
    final restored = AppState(prefs: await SharedPreferences.getInstance());
    await restored.load();
    expect(restored.reviewRequested, isTrue);
    expect(restored.usage, greaterThanOrEqualTo(const Duration(seconds: 3)));
  });

  test('a failed request is not retried', () async {
    final state = await testState();
    var requests = 0;
    final prompt = ReviewPrompt(
      state,
      after: Duration.zero,
      request: () async {
        requests++;
        throw Exception('store unavailable');
      },
    );
    prompt.tick();
    await Future<void>.delayed(Duration.zero);
    prompt.tick();
    expect(requests, 1);
  });

  test('usage carries over between launches', () async {
    final state = await testState();
    for (var i = 0; i < 30; i++) {
      state.addUsage(const Duration(seconds: 1));
    }
    final restored = AppState(prefs: await SharedPreferences.getInstance());
    await restored.load();
    expect(restored.usage, const Duration(seconds: 30));
    expect(restored.reviewRequested, isFalse);
  });
}
