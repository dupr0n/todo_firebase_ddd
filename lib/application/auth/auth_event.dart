part of 'auth_bloc.dart';

@freezed
abstract class AuthEvent with _$AuthEvent {
  //* Standard naming convention of union cases is to use actions in past tense
  const factory AuthEvent.authCheckRequested() = AuthCheckRequested;
  const factory AuthEvent.signedOut() = SignedOut;
}
