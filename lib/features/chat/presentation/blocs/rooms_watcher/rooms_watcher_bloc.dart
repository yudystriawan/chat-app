import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/usecases/get_chat_rooms.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/entity.dart';

part 'rooms_watcher_bloc.freezed.dart';
part 'rooms_watcher_event.dart';
part 'rooms_watcher_state.dart';

@injectable
class RoomsWatcherBloc extends Bloc<RoomsWatcherEvent, RoomsWatcherState> {
  final GetChatRooms _getChatRooms;

  StreamSubscription<Either<Failure, KtList<Room>>>? _roomsStreamSubscription;

  RoomsWatcherBloc(
    this._getChatRooms,
  ) : super(RoomsWatcherState.initial()) {
    on<_WatchAllStarted>(_onWatchAllStarted);
    on<_SearchTermChanged>(_onSearchTermChanged);
    on<_RoomsReceived>(_onRoomsReceived);
  }

  void _onWatchAllStarted(
    _WatchAllStarted event,
    Emitter<RoomsWatcherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _roomsStreamSubscription?.cancel();
    _roomsStreamSubscription = _getChatRooms(const NoParams()).listen(
        (failureOrRooms) =>
            add(RoomsWatcherEvent.roomsReceived(failureOrRooms)));
  }

  void _onSearchTermChanged(
    _SearchTermChanged event,
    Emitter<RoomsWatcherState> emit,
  ) async {}

  void _onRoomsReceived(
    _RoomsReceived event,
    Emitter<RoomsWatcherState> emit,
  ) async {
    final newState = state.copyWith(failureOption: none(), isLoading: false);

    emit(event.failureOrRooms.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (rooms) => newState.copyWith(rooms: rooms),
    ));
  }
}