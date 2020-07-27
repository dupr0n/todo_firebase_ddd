import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_firebase_ddd/domain/auth/auth_failure.dart';

import 'value_objects.dart';

abstract class IAuthFacade {
  //* Unit is an empty tuple. Its used in place of void, cause void can't be used by Either
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    @required EmailAddress emailAddress,
    @required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}
