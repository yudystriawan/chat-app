part of 'account_watcher_bloc.dart';

@freezed
@freezed
class AccountWatcherState with _$AccountWatcherState {
  const factory AccountWatcherState({
    required Account account,
    required Option<Failure> failureOption,
    @Default(false) isFetching,
  }) = _AccountWatcherState;

  factory AccountWatcherState.initial() => AccountWatcherState(
        account: Account.empty(),
        failureOption: none(),
      );
}
