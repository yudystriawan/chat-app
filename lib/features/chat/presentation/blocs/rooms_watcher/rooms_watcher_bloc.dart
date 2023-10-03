import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../../domain/usecases/watch_chat_rooms.dart';
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
  final WatchChatRooms _getChatRooms;

  StreamSubscription<Either<Failure, KtList<Room>>>? _roomsStreamSubscription;

  RoomsWatcherBloc(
    this._getChatRooms,
  ) : super(RoomsWatcherState.initial()) {
    on<_WatchAllStarted>(_onWatchAllStarted, transformer: concurrent());
    on<_SearchTermChanged>(_onSearchTermChanged, transformer: concurrent());
    on<_RoomsReceived>(_onRoomsReceived, transformer: concurrent());
  }

  @override
  Future<void> close() async {
    await _roomsStreamSubscription?.cancel();
    return super.close();
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
