part of 'room_actor_bloc.dart';

@freezed
class RoomActorState with _$RoomActorState {
  const factory RoomActorState.initial() = _Initial;
  const factory RoomActorState.actionInProgress() = _ActionInProgress;
  const factory RoomActorState.actionFailure(Failure failure) = _ActionFailure;
  const factory RoomActorState.removeRoomSuccess() = _RemoveRoomSuccess;
  const factory RoomActorState.addRoomSuccess(String roomId) = _AddRoomSuccess;
  const factory RoomActorState.enterRoomSuccess(String roomId) =
      _EnterRoomSuccess;
  const factory RoomActorState.exitRoomSuccess(String roomId) =
      _ExitRoomSuccess;
}
