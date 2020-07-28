import 'package:dartz/dartz.dart';

import '../core/failures.dart';
import '../core/value_object.dart';
import '../core/value_validators.dart';

class EmailAddress extends ValueObject<String> {
  factory EmailAddress(String input) {
    assert(input != null);
    return EmailAddress._(validateEmailAddress(input));
  }

  @override
  final Either<ValueFailure<String>, String> value;
  const EmailAddress._(this.value);
}

class Password extends ValueObject<String> {
  factory Password(String input) {
    assert(input != null);
    return Password._(validateShortPassword(input));
  }

  @override
  final Either<ValueFailure<String>, String> value;
  const Password._(this.value);
}
