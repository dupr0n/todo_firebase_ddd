import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo_firebase_ddd/domain/core/errors.dart';

import 'failures.dart';

@immutable
abstract class ValueObject<T> {
  const ValueObject();
  Either<ValueFailure<T>, T> get value;

  bool isValid() => value.isRight();

  /// Throws [UnexpectedValueError] containing the [ValueError]
  T getOrCrash() => value.fold((l) => throw UnexpectedValueError(l), id); //# id is same as (r) => r

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
    return o is ValueObject<T> && o.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'ValueObject(value: $value)';
}
