part of 'messages_watcher_bloc.dart';

@freezed
class MessagesWatcherState with _$MessagesWatcherState {
  const factory MessagesWatcherState({
    required KtList<Message> messages,
    required Option<Failure> failureOption,
    @Default(false) bool isLoading,
  }) = _MessagesWatcherState;

  factory MessagesWatcherState.initial() => MessagesWatcherState(
      messages: const KtList.empty(), failureOption: none());
}
