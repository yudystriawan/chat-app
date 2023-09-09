part of 'member_watcher_bloc.dart';

@freezed
class MemberWatcherEvent with _$MemberWatcherEvent {
  const factory MemberWatcherEvent.watchAllStarted(KtList<String> memberIds) =
      _WatchAllStarted;
  const factory MemberWatcherEvent.membersReceived(
      Either<Failure, KtList<Member>> failureOrMembers) = _MembersReceived;
}
