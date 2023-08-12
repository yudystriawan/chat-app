part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const AuthState._();
  const factory AuthState({
    required Option<Failure> failureOption,
    required User user,
    required AuthStatus status,
  }) = _AuthState;

  factory AuthState.initial() => AuthState(
        user: User.empty(),
        failureOption: none(),
        status: AuthStatus.initial,
      );

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

enum AuthStatus {
  initial,
  authenticated,
  unAuthenticated,
}
