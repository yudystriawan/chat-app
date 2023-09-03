part of 'account_watcher_bloc.dart';

@freezed
class AccountWatcherEvent with _$AccountWatcherEvent {
  const factory AccountWatcherEvent.started() = _Started;
  const factory AccountWatcherEvent.accountReceived(
      Either<Failure, Account> failureOrAccount) = _AccountReceived;
}
