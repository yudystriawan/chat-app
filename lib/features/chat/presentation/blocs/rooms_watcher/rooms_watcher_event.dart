part of 'rooms_watcher_bloc.dart';

@freezed
class RoomsWatcherEvent with _$RoomsWatcherEvent {
  const factory RoomsWatcherEvent.watchAllStarted() = _WatchAllStarted;
  const factory RoomsWatcherEvent.searchTermChanged(String searchTerm) =
      _SearchTermChanged;
  const factory RoomsWatcherEvent.roomsReceived(
      Either<Failure, KtList<Room>> failureOrRooms) = _RoomsReceived;
}
