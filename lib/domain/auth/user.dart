import 'package:freezed_annotation/freezed_annotation.dart';

import '../core/value_object.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @required UniqueId id,
  }) = _User;
}
