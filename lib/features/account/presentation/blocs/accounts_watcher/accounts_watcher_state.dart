part of 'accounts_watcher_bloc.dart';

@freezed
class AccountsWatcherState with _$AccountsWatcherState {
  const factory AccountsWatcherState.initial() = _Initial;
  const factory AccountsWatcherState.loadInProgress() = _LoadInProgress;
  const factory AccountsWatcherState.loadFailure(Failure failure) =
      _LoadFailure;
  const factory AccountsWatcherState.loadSuccess(KtList<Account> accounts) =
      _LoadSuccess;
}
