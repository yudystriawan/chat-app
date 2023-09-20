part of 'last_message_watcher_bloc.dart';

@freezed
class LastMessageWatcherEvent with _$LastMessageWatcherEvent {
  const factory LastMessageWatcherEvent.watchStarted(String roomId) =
      _WatchStarted;
  const factory LastMessageWatcherEvent.messageReceived(
      Either<Failure, Message> failureOrMessage) = _MessageReceived;
}
