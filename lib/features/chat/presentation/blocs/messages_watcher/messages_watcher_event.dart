part of 'messages_watcher_bloc.dart';

@freezed
class MessagesWatcherEvent with _$MessagesWatcherEvent {
  const factory MessagesWatcherEvent.watchAllStarted(String roomId) =
      _WatchAllStarted;
  const factory MessagesWatcherEvent.messagesReceived(
      Either<Failure, KtList<Message>> failureOrMessages) = _MessagesReceived;
}
