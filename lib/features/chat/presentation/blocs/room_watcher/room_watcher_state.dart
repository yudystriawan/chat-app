part of 'room_watcher_bloc.dart';

@freezed
@freezed
class RoomWatcherState with _$RoomWatcherState {
  const factory RoomWatcherState({
    required KtList<Room> rooms,
    required Option<Failure> failureOption,
    required String searchTerm,
    @Default(false) bool isLoading,
  }) = _RoomWatcherState;

  factory RoomWatcherState.initial() => RoomWatcherState(
        rooms: const KtList.empty(),
        failureOption: none(),
        searchTerm: '',
      );
}
