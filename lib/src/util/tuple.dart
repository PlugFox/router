import 'package:meta/meta.dart';

// TODO: Replace with patterns
// Matiunin Mikhail <plugfox@gmail.com>, 06 January 2023

@internal
@immutable
class Tuple<A, B> {
  const Tuple(this.a, this.b);

  final A a;
  final B b;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Tuple &&
          runtimeType == other.runtimeType &&
          a == other.a &&
          b == other.b;

  @override
  int get hashCode => a.hashCode ^ b.hashCode;

  @override
  String toString() => 'Tuple{a: $a, b: $b}';
}
