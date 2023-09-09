part of 'room_watcher_bloc.dart';

@freezed
class RoomWatcherState with _$RoomWatcherState {
  const factory RoomWatcherState({
    required Room room,
    required Option<Failure> failureOption,
    @Default(false) bool isLoading,
  }) = _RoomWatcherState;

  factory RoomWatcherState.initial() => RoomWatcherState(
        room: Room.empty(),
        failureOption: none(),
      );
}
