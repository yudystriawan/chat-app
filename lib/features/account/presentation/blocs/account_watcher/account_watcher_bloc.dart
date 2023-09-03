import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/account/domain/usecases/watch_account.dart';
import 'package:core/core.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/account.dart';

part 'account_watcher_bloc.freezed.dart';
part 'account_watcher_event.dart';
part 'account_watcher_state.dart';

@injectable
class AccountWatcherBloc
    extends Bloc<AccountWatcherEvent, AccountWatcherState> {
  final WatchAccount _watchAccount;

  StreamSubscription<Either<Failure, Account>>? _accountStreamSubsctiption;

  AccountWatcherBloc(this._watchAccount)
      : super(AccountWatcherState.initial()) {
    on<_Started>(_onStarted);
    on<_AccountReceived>(_onAccountReceived);
  }

  void _onStarted(
    _Started event,
    Emitter<AccountWatcherState> emit,
  ) async {
    emit(state.copyWith(isFetching: true));
    await _accountStreamSubsctiption?.cancel();
    _accountStreamSubsctiption = _watchAccount(const NoParams())
        .listen((event) => add(AccountWatcherEvent.accountReceived(event)));
  }

  void _onAccountReceived(
    _AccountReceived event,
    Emitter<AccountWatcherState> emit,
  ) async {
    final newState = state.copyWith(
      isFetching: false,
      failureOption: none(),
    );
    emit(event.failureOrAccount.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (account) => newState.copyWith(account: account),
    ));
  }
}
