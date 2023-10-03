import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/usecases/watch_last_message.dart';

part 'last_message_watcher_bloc.freezed.dart';
part 'last_message_watcher_event.dart';
part 'last_message_watcher_state.dart';

@injectable
class LastMessageWatcherBloc
    extends Bloc<LastMessageWatcherEvent, LastMessageWatcherState> {
  final WatchLastMessage _watchLastMessage;

  StreamSubscription<Either<Failure, Message>>? _messageStreamSubscription;

  LastMessageWatcherBloc(this._watchLastMessage)
      : super(LastMessageWatcherState.initial()) {
    on<_WatchStarted>(_onWatchStarted, transformer: concurrent());
    on<_MessageReceived>(_onMessageReceived, transformer: concurrent());
  }

  void _onWatchStarted(
    _WatchStarted event,
    Emitter<LastMessageWatcherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _messageStreamSubscription?.cancel();

    _messageStreamSubscription = _watchLastMessage(
      WatchLastMessageParams(event.roomId),
    ).listen(
      (failureOrMessage) => add(
        LastMessageWatcherEvent.messageReceived(failureOrMessage),
      ),
    );
  }

  void _onMessageReceived(
    _MessageReceived event,
    Emitter<LastMessageWatcherState> emit,
  ) async {
    final newState = state.copyWith(
      isLoading: false,
      failureOption: none(),
    );

    emit(event.failureOrMessage.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (message) => newState.copyWith(message: message),
    ));
  }
}
