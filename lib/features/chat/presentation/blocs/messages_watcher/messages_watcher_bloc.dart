import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:chat_app/features/chat/domain/usecases/get_messages.dart';
import 'package:chat_app/features/chat/domain/usecases/get_unread_messages.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../../domain/entities/entity.dart';

part 'messages_watcher_bloc.freezed.dart';
part 'messages_watcher_event.dart';
part 'messages_watcher_state.dart';

@injectable
class MessagesWatcherBloc
    extends Bloc<MessagesWatcherEvent, MessagesWatcherState> {
  final GetMessages _getMessages;
  final GetUnreadMessages _getUnreadMessages;

  StreamSubscription<Either<Failure, KtList<Message>>>?
      _messageStreamSubscription;

  MessagesWatcherBloc(
    this._getMessages,
    this._getUnreadMessages,
  ) : super(MessagesWatcherState.initial()) {
    on<_WatchAllStarted>(
      _onWatchAllStarted,
      transformer: concurrent(),
    );
    on<_WatchUnreadStarted>(
      _onWatchUnreadStarted,
      transformer: concurrent(),
    );
    on<_MessagesReceived>(
      _onMessageReceived,
      transformer: concurrent(),
    );
  }

  @override
  Future<void> close() async {
    await _messageStreamSubscription?.cancel();
    return super.close();
  }

  void _onWatchAllStarted(
    _WatchAllStarted event,
    Emitter<MessagesWatcherState> emit,
  ) async {
    var newState = state.copyWith(isLoading: true);

    if (_messageStreamSubscription != null) {
      newState = newState.copyWith(
        currentPage: newState.currentPage + 1,
      );
    }

    emit(newState);

    await _messageStreamSubscription?.cancel();

    _messageStreamSubscription = _getMessages(
      GetMessagesParams(
        roomId: event.roomId,
        limit: state.limit,
      ),
    ).listen(
      (failureOrMessages) => add(
        MessagesWatcherEvent.messagesReceived(failureOrMessages),
      ),
    );
  }

  void _onMessageReceived(
    _MessagesReceived event,
    Emitter<MessagesWatcherState> emit,
  ) async {
    final newState = state.copyWith(isLoading: false, failureOption: none());

    emit(event.failureOrMessages.fold(
      (f) => newState.copyWith(failureOption: optionOf(f)),
      (messages) => newState.copyWith(messages: messages),
    ));
  }

  void _onWatchUnreadStarted(
    _WatchUnreadStarted event,
    Emitter<MessagesWatcherState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    await _messageStreamSubscription?.cancel();

    _messageStreamSubscription = _getUnreadMessages(
      GetUnreadMessagesParams(
        roomId: event.roomId,
      ),
    ).listen(
      (failureOrMessages) => add(
        MessagesWatcherEvent.messagesReceived(failureOrMessages),
      ),
    );
  }
}
