import 'package:todo_firebase_ddd/domain/core/failures.dart';

class NotAuthenticatedError extends Error {}

class UnexpectedValueError extends Error {
  final ValueFailure valueFailure;

  UnexpectedValueError(this.valueFailure);

  @override
  String toString() {
    const String explanation = 'Encountered a ValueFailure at an unrecoverable point. Terminating';
    return Error.safeToString('$explanation Failure: $valueFailure');
  }
}
