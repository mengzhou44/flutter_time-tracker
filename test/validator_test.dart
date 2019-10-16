import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/app/sign-in/validators.dart';

void main() {
  test('non empty string', () {
     final validator = NonEmptyStringValidator();
      expect(validator.isValid('test'), true);
  });

  test('null string', () {
     final validator = NonEmptyStringValidator();
      expect(validator.isValid(null), false);
  });
}
