import 'dart:async';

import 'package:meta/meta.dart';

/// Evaluates [fn] and returns the result.
/// Allows you to lighten the load on the event loop and ensure the order.
@internal
Future<T> $eval<T>(Future<T> Function(FutureOr<void> Function() sleep) fn) {
  final stopwatch = Stopwatch()..start();
  FutureOr<void> sleep() => stopwatch.elapsedMilliseconds < 8
      ? Future<void>.delayed(Duration.zero, stopwatch.reset)
      : null;
  return fn(sleep).whenComplete(stopwatch.stop);
}
