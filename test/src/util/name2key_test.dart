import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/src/util/utils.dart';

void main() => group('Utils.name2key', () {
      String map(String name) => Utils.name2key(name);

      test('cornercase', () {
        expect(() => map(''), returnsNormally);
        expect(() => map(' '), returnsNormally);
        expect(() => map('\n'), returnsNormally);
        expect(() => map('-'), returnsNormally);
        expect(() => map('-a-'), returnsNormally);
      });

      test('symbols', () {
        expect(map(''), equals(''));
        expect(map(' '), equals(''));
        expect(map('\n\n'), equals(''));
        expect(map('_'), equals(''));
        expect(map('-'), equals(''));
        expect(map('---'), equals(''));
        expect(map('\n-\n'), equals(''));
        expect(map('_-_'), equals(''));
        expect(map('-_-'), equals(''));
        expect(map('- -'), equals(''));
        expect(map(' - '), equals(''));
      });

      test('letters', () {
        expect(map('abc'), equals('abc'));
        expect(map('ABC'), equals('abc'));
        expect(map('AbC'), equals('abc'));
        expect(map('aBc'), equals('abc'));
        expect(map(' A b c '), equals('a-b-c'));
        expect(map('-A-b-c-'), equals('a-b-c'));
        expect(map('--Abc--'), equals('abc'));
        expect(map('A--b--c'), equals('a-b-c'));
        expect(map(' _ A+b+c _ '), equals('a-b-c'));
      });

      test('numbers', () {
        expect(map('123'), equals('123'));
        expect(map('A1B'), equals('a1b'));
        expect(map('1B2'), equals('1b2'));
        expect(map('1b2'), equals('1b2'));
        expect(map(' 1 2 3 '), equals('1-2-3'));
        expect(map('-1-23-'), equals('1-23'));
        expect(map('--123--'), equals('123'));
        expect(map('1--2--3'), equals('1-2-3'));
        expect(map(' _ 1.&+2\n* \n 3_ -'), equals('1-2-3'));
      });
    });
