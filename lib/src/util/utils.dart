
import 'package:meta/meta.dart';

/// {@nodoc}
@sealed
@internal
abstract class Utils {
  Utils._();

  /// Replace all non-alphanumeric characters with underscores
  @experimental
  static String name2key(String name) {
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
      } else if (j == 0 || codeUnits[j - 1] != 95) {
        continue; // Current character is already '-'
      } else {
        writeNext(45); // Replace all other characters with '-'
      }
    }
    // Remove trailing underscore
    if (j < length && codeUnits[j] == 95) j--;
    if (j == 0) return '';

    return String.fromCharCodes(codeUnits.take(j));
  }
}
