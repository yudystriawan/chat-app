import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/usecases/create_message.dart';
import 'package:core/features/images/domain/usecases/upload_image.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'message_form_bloc.freezed.dart';
part 'message_form_event.dart';
part 'message_form_state.dart';

@injectable
class MessageFormBloc extends Bloc<MessageFormEvent, MessageFormState> {
  final CreateMessage _createMessage;
  final UploadImage _uploadImage;

  MessageFormBloc(
    this._createMessage,
    this._uploadImage,
  ) : super(MessageFormState.initial()) {
    on<_Initialized>((event, emit) {
      // TODO: implement event handler
    });
    on<_DataChanged>(_onDataChanged);
    on<_ImageFileChanged>(_onImageFileChanged);
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
      failureOrSuccessOption: none(),
    ));
  }

  void _onSubmitted(
    _Submitted event,
    Emitter<MessageFormState> emit,
  ) async {
    if (state.data.isEmpty) return;

    emit(state.copyWith(
      isSubmitting: true,
      failureOrSuccessOption: none(),
    ));

    String? imageUrl;
    if (state.imageFile != null) {
      final failureOrImageUrl =
          await _uploadImage.call(UploadImageParams(state.imageFile!));

      if (failureOrImageUrl.isLeft()) {
        emit(state.copyWith(
          isSubmitting: false,
          failureOrSuccessOption: optionOf(failureOrImageUrl.map((_) => unit)),
        ));
        return;
      }

      imageUrl = failureOrImageUrl.fold(
        (_) => null,
        (imageUrl) => imageUrl,
      );
    }

    final failureOrSuccess = await _createMessage(CreateMessageParams(
      roomId: event.roomId,
      message: state.data,
      imageUrl: imageUrl,
    ));

    emit(MessageFormState.initial().copyWith(
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
