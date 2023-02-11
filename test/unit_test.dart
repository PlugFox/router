import 'package:flutter_test/flutter_test.dart';

import 'src/parser/information_parser_test.dart' as information_parser;
import 'src/parser/state_decoder_test.dart' as state_decoder;
import 'src/parser/state_encoder_test.dart' as state_encoder;
import 'src/util/name2key_test.dart' as name2key;

void main() {
  group('unit', () {
    name2key.main();
    state_decoder.main();
    state_encoder.main();
    information_parser.main();
  });
}
