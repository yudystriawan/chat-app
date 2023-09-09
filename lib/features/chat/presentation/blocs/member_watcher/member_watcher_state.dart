part of 'member_watcher_bloc.dart';

@freezed
class MemberWatcherState with _$MemberWatcherState {
  const factory MemberWatcherState({
    required KtList<Member> members,
    required Option<Failure> failureOption,
    @Default(false) bool isLoading,
  }) = _MemberWatcherState;

  factory MemberWatcherState.initial() => MemberWatcherState(
        members: const KtList.empty(),
        failureOption: none(),
      );
}
