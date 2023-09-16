part of 'room_actor_bloc.dart';

@freezed
class RoomActorEvent with _$RoomActorEvent {
  const factory RoomActorEvent.roomRemoved(String roomId) = _RoomRemoved;
  const factory RoomActorEvent.roomAdded({
    required KtList<String> userIds,
    required RoomType type,
  }) = _RoomAdded;
  const factory RoomActorEvent.roomEntered(String roomId) = _RoomEntered;
  const factory RoomActorEvent.roomExited(String roomId) = _RoomExited;
}
