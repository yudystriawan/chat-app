import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/account/domain/usecases/watch_accounts.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/account.dart';

part 'accounts_watcher_bloc.freezed.dart';
part 'accounts_watcher_event.dart';
part 'accounts_watcher_state.dart';

@injectable
class AccountsWatcherBloc
    extends Bloc<AccountsWatcherEvent, AccountsWatcherState> {
  final WatchAccounts _watchAccounts;

  StreamSubscription<Either<Failure, KtList<Account>>>?
      _accountsStreamSubscription;

  AccountsWatcherBloc(this._watchAccounts)
      : super(const AccountsWatcherState.initial()) {
    on<_WatchStarted>(_onWatchStarted);
    on<_AccountsReceived>(_onAccountsReceived);
  }

  void _onWatchStarted(
    _WatchStarted event,
    Emitter<AccountsWatcherState> emit,
  ) async {
    emit(const AccountsWatcherState.loadInProgress());
    await _accountsStreamSubscription?.cancel();
    _accountsStreamSubscription =
        _watchAccounts(WatchAccountsParams(username: event.username)).listen(
            (accounts) => add(AccountsWatcherEvent.accountsReceived(accounts)));
  }

  void _onAccountsReceived(
    _AccountsReceived event,
    Emitter<AccountsWatcherState> emit,
  ) async {
    emit(event.failureOrAccounts.fold(
      (f) => AccountsWatcherState.loadFailure(f),
      (accounts) => AccountsWatcherState.loadSuccess(accounts),
    ));
  }
}
