import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Emits the current time once a second. Screens that need a live countdown
/// or a live elapsed-time timer just `watch` this and recompute a duration
/// from their own stored timestamps — no per-screen Timer/dispose bookkeeping.
final tickerProvider = StreamProvider<DateTime>((ref) {
  return Stream<DateTime>.periodic(const Duration(seconds: 1), (_) => DateTime.now())
      .asBroadcastStream()
      .map((_) => DateTime.now());
});
