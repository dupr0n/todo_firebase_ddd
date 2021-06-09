import 'package:firebase_auth/firebase_auth.dart' as firebase;

import '../../domain/auth/user.dart';
import '../../domain/core/value_object.dart';

extension FirebaseUserDomainX on firebase.User {
  User toDomain() => User(id: UniqueId.fromUniqueString(uid));
}
