part of 'rooms_watcher_bloc.dart';

@freezed
@freezed
class RoomsWatcherState with _$RoomsWatcherState {
  const factory RoomsWatcherState({
    required KtList<Room> rooms,
    required Option<Failure> failureOption,
    required String searchTerm,
    @Default(false) bool isLoading,
  }) = _RoomWatcherState;

  factory RoomsWatcherState.initial() => RoomsWatcherState(
        rooms: const KtList.empty(),
        failureOption: none(),
        searchTerm: '',
      );
}
