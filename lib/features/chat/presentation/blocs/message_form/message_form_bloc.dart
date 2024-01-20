import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/usecases/add_message.dart';

part 'message_form_bloc.freezed.dart';
part 'message_form_event.dart';
part 'message_form_state.dart';

@injectable
class MessageFormBloc extends Bloc<MessageFormEvent, MessageFormState> {
  final AddMessage _createMessage;

  MessageFormBloc(
    this._createMessage,
  ) : super(MessageFormState.initial()) {
    on<_Initialized>((event, emit) {
      // TODO: implement event handler
    });
    on<_DataChanged>(_onDataChanged);
    on<_ImageFileChanged>(_onImageFileChanged);
    on<_ReplyMessageChanged>(_onReplyMessageChanged);
    on<_Submitted>(_onSubmitted);
  }

  void _onDataChanged(
    _DataChanged event,
    Emitter<MessageFormState> emit,
  ) async {
    emit(state.copyWith(
      data: event.dataStr,
      failureOrSuccessOption: none(),
    ));
  }

  void _onImageFileChanged(
    _ImageFileChanged event,
    Emitter<MessageFormState> emit,
  ) async {
    emit(state.copyWith(
      imageFile: event.file,
      messageType: event.file == null ? MessageType.text : MessageType.image,
      failureOrSuccessOption: none(),
    ));
  }

  void _onReplyMessageChanged(
    _ReplyMessageChanged event,
    Emitter<MessageFormState> emit,
  ) async {
    emit(state.copyWith(
      replyMessage: event.message,
      failureOrSuccessOption: none(),
    ));
  }

  void _onSubmitted(
    _Submitted event,
    Emitter<MessageFormState> emit,
  ) async {
    if (state.data.isEmpty && state.imageFile == null) return;

    emit(state.copyWith(
      isSubmitting: true,
      failureOrSuccessOption: none(),
    ));

    final failureOrMessage = await _createMessage(AddMessageParams(
      roomId: event.roomId,
      message: state.data,
      replyMessage: state.replyMessage,
      image: state.imageFile,
    ));

    // change right value to unit.
    var failureOrUnit = failureOrMessage.map((r) => unit);

    MessageFormState newState = state;
    if (failureOrUnit.isRight()) {
      newState = newState.copyWith(imageFile: null);
    }

    emit(newState.copyWith(
      failureOrSuccessOption: optionOf(failureOrUnit),
      isSubmitting: false,
    ));
  }
}
