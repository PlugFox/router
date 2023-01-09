import 'package:meta/meta.dart';

@sealed
@internal
abstract class UriUtils {
  UriUtils._();
/*
  static Tuple<String, Map<String, Object?>?> decodeSegment(String segment) {
    final index = segment.indexOf('@');
    final path = index > 0 ? segment.substring(0, index) : segment;
    final entries = (index > 0 ? segment.substring(index + 1) : '')
        .split('&')
        .expand<MapEntry<String, String>>((e) sync* {
      final index = segment.indexOf('=');
      if (index <= 0) return;
      yield MapEntry(segment.substring(0, index), segment.substring(index + 1));
    }).toList(growable: false);
    final arguments = <String, String>{
      for (final entry in entries) entry.key: entry.value,
    };
    return Tuple(path, arguments);
  }

  static Tuple<String, Map<String, Object?>?> routeInformationFromLocation(
    String location, [
    Map<String, Object?>? state,
  ]) {
    // Active route
    final uri = Uri.tryParse(location);
    if (uri == null) {
      assert(false, 'Invalid route information location');
      return Tuple('/', state);
    }
    final newState = <String, Object?>{
      ...?state,
    };

    var node = newState;
    for (final segment in uri.pathSegments) {
      final nextNode = node[segment];
      if (nextNode is! Map<String, Object?>) {
        break;
      }
      node = node[segment];
    }
    /* for (final entry in r.queryParametersAll.entries) {
      state[entry.key] = <String, Object?>{};
      for (final value in entry.value) {
        final keyValue = value.split('=');
        if (keyValue.length == 2) {
          state[entry.key]![keyValue[0]] = keyValue[1];
        }
      }
    } */

    return Tuple(uri.path, newState);
  } */
}
