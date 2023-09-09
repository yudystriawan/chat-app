import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/usecases/get_chat_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/entity.dart';

part 'room_watcher_bloc.freezed.dart';
part 'room_watcher_event.dart';
part 'room_watcher_state.dart';

@injectable
class RoomWatcherBloc extends Bloc<RoomWatcherEvent, RoomWatcherState> {
  final GetChatRoom _getChatRoom;

  StreamSubscription<Either<Failure, Room>>? _roomStreamSubscription;

  RoomWatcherBloc(
    this._getChatRoom,
  ) : super(RoomWatcherState.initial()) {
    on<_WatchStarted>(_onWatchStarted);
    on<_RoomReceived>(_onRoomReceived);
  }

  void _onWatchStarted(
    _WatchStarted event,
    Emitter<RoomWatcherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _roomStreamSubscription?.cancel();

    _roomStreamSubscription =
        _getChatRoom(GetChatRoomParams(roomId: event.roomId)).listen(
            (failureOrRoom) =>
                add(RoomWatcherEvent.roomReceived(failureOrRoom)));
  }

  void _onRoomReceived(
    _RoomReceived event,
    Emitter<RoomWatcherState> emit,
  ) async {
    final newState = state.copyWith(isLoading: false, failureOption: none());

    emit(event.failureOrRoom.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (room) => newState.copyWith(room: room),
    ));
  }
}
