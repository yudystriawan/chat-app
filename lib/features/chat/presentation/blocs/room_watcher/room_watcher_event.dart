part of 'room_watcher_bloc.dart';

@freezed
class RoomWatcherEvent with _$RoomWatcherEvent {
  const factory RoomWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory RoomWatcherEvent.searchTermChanged(String searchTerm) =
      _SearchTermChanged;
  const factory RoomWatcherEvent.roomsReceived(
      Either<Failure, KtList<Room>> failureOrRooms) = _RoomsReceived;
}
