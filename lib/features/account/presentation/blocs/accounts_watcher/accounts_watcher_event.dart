part of 'accounts_watcher_bloc.dart';

@freezed
class AccountsWatcherEvent with _$AccountsWatcherEvent {
  const factory AccountsWatcherEvent.watchStarted({String? username}) =
      _WatchStarted;
  const factory AccountsWatcherEvent.accountsReceived(
      Either<Failure, KtList<Account>> failureOrAccounts) = _AccountsReceived;
}
