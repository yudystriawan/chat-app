import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/features/chat/domain/usecases/add_room.dart';
import 'package:chat_app/features/chat/domain/usecases/enter_room.dart';
import 'package:chat_app/features/chat/domain/usecases/exit_room.dart';
import 'package:chat_app/features/chat/domain/usecases/remove_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/entity.dart';

part 'room_actor_bloc.freezed.dart';
part 'room_actor_event.dart';
part 'room_actor_state.dart';

@injectable
class RoomActorBloc extends Bloc<RoomActorEvent, RoomActorState> {
  final RemoveRoom _deleteRoom;
  final AddRoom _createRoom;
  final EnterRoom _enterRoom;
  final ExitRoom _exitRoom;

  RoomActorBloc(
    this._deleteRoom,
    this._createRoom,
    this._enterRoom,
    this._exitRoom,
  ) : super(const RoomActorState.initial()) {
    on<_RoomAdded>(_onRoomAdded);
    on<_RoomRemoved>(_onRoomRemoved);
    on<_RoomEntered>(_onRoomEntered, transformer: sequential());
    on<_RoomExited>(_onRoomExited, transformer: sequential());
  }

  void _onRoomAdded(
    _RoomAdded event,
    Emitter<RoomActorState> emit,
  ) async {
    emit(const RoomActorState.actionInProgress());

    final failureOrSuccess = await _createRoom(CreateRoomParams(
      members: event.userIds,
      type: event.type,
    ));

    emit(failureOrSuccess.fold(
      (f) => RoomActorState.actionFailure(f),
      (roomId) => RoomActorState.addRoomSuccess(roomId),
    ));
  }

  void _onRoomRemoved(
    _RoomRemoved event,
    Emitter<RoomActorState> emit,
  ) async {
    emit(const RoomActorState.actionInProgress());

    final failureOrSuccess = await _deleteRoom(DeleteRoomParams(event.roomId));

    emit(failureOrSuccess.fold(
      (f) => RoomActorState.actionFailure(f),
      (_) => const RoomActorState.removeRoomSuccess(),
    ));
  }

  void _onRoomEntered(
    _RoomEntered event,
    Emitter<RoomActorState> emit,
  ) async {
    final failureOrSuccess = await _enterRoom(EnterRoomParams(event.roomId));

    emit(failureOrSuccess.fold(
      (f) => RoomActorState.actionFailure(f),
      (_) => RoomActorState.enterRoomSuccess(event.roomId),
    ));
  }

  void _onRoomExited(
    _RoomExited event,
    Emitter<RoomActorState> emit,
  ) async {
    final failureOrSuccess = await _exitRoom(ExitRoomParams(event.roomId));

    emit(failureOrSuccess.fold(
      (f) => RoomActorState.actionFailure(f),
      (_) => RoomActorState.exitRoomSuccess(event.roomId),
    ));
  }
}
