import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_review/in_app_review.dart';

import 'app_state.dart';

/// Asks once, ever, for a store rating after [after] of total use. Use is only
/// counted while the app is on screen, and the prompt waits for a pause in
/// typing so the dialog never lands mid-calculation.
class ReviewPrompt {
  ReviewPrompt(
    this.state, {
    this.after = const Duration(minutes: 5),
    Future<void> Function()? request,
    DateTime Function()? now,
  }) : _request = request ?? _storeReview,
       _now = now ?? DateTime.now;

  final AppState state;
  final Duration after;
  final Future<void> Function() _request;
  final DateTime Function() _now;
  Timer? _timer;

  /// Only the Play Store and App Store builds can ask for a rating.
  static bool get supported =>
      !kIsWeb && (defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS);

  void start() {
    if (state.reviewRequested || _timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  @visibleForTesting
  void tick() {
    if (state.reviewRequested) return stop();
    state.addUsage(const Duration(seconds: 1));
    if (state.usage < after) return;
    final last = state.lastInteraction;
    if (last != null && _now().difference(last) < const Duration(seconds: 3)) return;
    // Marked first, so a failed or dismissed request is never repeated.
    state.markReviewRequested();
    stop();
    _request().catchError((Object e) => debugPrint('Review request failed: $e'));
  }

  static Future<void> _storeReview() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) await review.requestReview();
  }
}
