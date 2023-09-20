part of 'last_message_watcher_bloc.dart';

@freezed
class LastMessageWatcherState with _$LastMessageWatcherState {
  const factory LastMessageWatcherState({
    required Message message,
    required Option<Failure> failureOption,
    @Default(false) bool isLoading,
  }) = _LastMessageWatcherState;

  factory LastMessageWatcherState.initial() =>
      LastMessageWatcherState(message: Message.empty(), failureOption: none());
}
