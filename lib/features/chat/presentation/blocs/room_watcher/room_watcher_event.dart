part of 'room_watcher_bloc.dart';

@freezed
class RoomWatcherEvent with _$RoomWatcherEvent {
  const factory RoomWatcherEvent.watchStarted(String roomId) = _WatchStarted;
  const factory RoomWatcherEvent.roomReceived(
      Either<Failure, Room> failureOrRoom) = _RoomReceived;
}
