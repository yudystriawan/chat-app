part of 'messages_watcher_bloc.dart';

@freezed
class MessagesWatcherState with _$MessagesWatcherState {
  const MessagesWatcherState._();
  const factory MessagesWatcherState({
    required KtList<Message> messages,
    required Option<Failure> failureOption,
    @Default(false) bool isLoading,
    @Default(1) int currentPage,

    /// show page per size
    @Default(10) int pageSize,
  }) = _MessagesWatcherState;

  int get limit => currentPage * pageSize;

  factory MessagesWatcherState.initial() => MessagesWatcherState(
      messages: const KtList.empty(), failureOption: none());
}
