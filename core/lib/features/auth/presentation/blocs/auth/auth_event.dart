part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.watchUserStarted() = _WatchUserStarted;
  const factory AuthEvent.signOut() = _SignOut;
  const factory AuthEvent.userReceived(Either<Failure, User> failureOrUser) =
      _UserReceived;
}
