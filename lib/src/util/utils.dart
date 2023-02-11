import 'package:meta/meta.dart';

/// {@nodoc}
@sealed
@internal
abstract class Utils {
  Utils._();

  static final Map<String, String> _$name2key = <String, String>{};

  /// Replace all non-alphanumeric characters with underscores
  @experimental
  static String name2key(String name) {
    {
      // Check cache first to avoid unnecessary string operations
      final cache = _$name2key[name];
      if (cache != null) return cache;
    }

    final codeUnits = name.codeUnits.toList();
    final length = codeUnits.length;

    var j = 0;
    void writeNext(int codeUnit) {
      codeUnits[j] = codeUnit;
      j++;
    }

    for (var i = 0; i < length; i++) {
      final codeUnit = codeUnits[i];
      if (codeUnit > 96 && codeUnit < 123) {
        // a..z: 97..122
        writeNext(codeUnit); // Keep lowercase
      } else if (codeUnit > 47 && codeUnit < 58) {
        // 0..9: 48..57
        writeNext(codeUnit); // Keep numbers
      } else if (codeUnit > 64 && codeUnit < 91) {
        // A..Z: 65..90
        writeNext(codeUnit + 32); // Convert to lowercase
      } else if (j == 0 || codeUnits[j - 1] == 45) {
        continue; // Current character is already '-'
      } else {
        writeNext(45); // Replace all other characters with '-'
      }
    }

    {
      // Remove trailing underscore
      if (j > 0 && codeUnits[j - 1] == 45) j--;
      // Return empty string if name is empty
      if (j < 1) return _$name2key[name] = '';
    }

    return _$name2key[name] = String.fromCharCodes(codeUnits.take(j));
  }
}
