import 'dart:async';

import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/features/auth/domain/usecases/sign_out.dart';
import 'package:core/features/auth/domain/usecases/watch_user_auth.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignOut _signOut;
  final WatchUserAuth _watchUserAuth;
  final AuthProvider _authProvider;

  StreamSubscription<Either<Failure, User>>? _userAuthSubscription;

  AuthProvider get authProvider => _authProvider;

  AuthBloc(
    this._signOut,
    this._watchUserAuth,
    this._authProvider,
  ) : super(AuthState.initial()) {
    on<_WatchUserStarted>(_onWatchUserStarted);
    on<_SignOut>(_onSignOut);
    on<_UserReceived>(_onUserReceived);
  }

  void _onWatchUserStarted(
    _WatchUserStarted event,
    Emitter<AuthState> emit,
  ) async {
    await _userAuthSubscription?.cancel();
    _userAuthSubscription = _watchUserAuth(const NoParams()).listen(
      (failureOrUser) => add(AuthEvent.userReceived(failureOrUser)),
    );
  }

  void _onSignOut(
    _SignOut event,
    Emitter<AuthState> emit,
  ) async {
    final failureOrSuccess = await _signOut(const NoParams());
    emit(failureOrSuccess.fold(
      (l) => state,
      (_) => state.copyWith(
        user: User.empty(),
        status: AuthStatus.unAuthenticated,
      ),
    ));
    _authProvider.statusChanged(state.isAuthenticated);
  }

  void _onUserReceived(
    _UserReceived event,
    Emitter<AuthState> emit,
  ) async {
    emit(event.failureOrUser.fold(
      (f) => state.copyWith(
        failureOption: optionOf(f),
        status: AuthStatus.unAuthenticated,
      ),
      (user) => state.copyWith(
        failureOption: none(),
        user: user,
        status: AuthStatus.authenticated,
      ),
    ));
    _authProvider.statusChanged(state.isAuthenticated);
  }
}

@lazySingleton
class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  void statusChanged(bool isAuthenticated) {
    _isAuthenticated = isAuthenticated;
    notifyListeners();
  }
}
