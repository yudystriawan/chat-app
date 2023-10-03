import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:core/features/images/domain/usecases/upload_image.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/entity.dart';
import '../../../domain/usecases/add_message.dart';
import '../../../domain/usecases/edit_message.dart';

part 'message_form_bloc.freezed.dart';
part 'message_form_event.dart';
part 'message_form_state.dart';

@injectable
class MessageFormBloc extends Bloc<MessageFormEvent, MessageFormState> {
  final AddMessage _createMessage;
  final UploadImage _uploadImage;
  final EditMessage _editMessage;

  MessageFormBloc(
    this._createMessage,
    this._uploadImage,
    this._editMessage,
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

    final imageFile = state.imageFile;

    emit(state.copyWith(
      isSubmitting: true,
      failureOrSuccessOption: none(),
    ));

    final failureOrMessage = await _createMessage(AddMessageParams(
      roomId: event.roomId,
      message: state.data,
      type: state.messageType,
      replyMessage: state.replyMessage,
    ));

    // change right value to unit.
    var failureOrUnit = failureOrMessage.map((r) => unit);

    // emit state when create message success, and if type is image upload file.
    if (failureOrUnit.isRight()) {
      emit(MessageFormState.initial().copyWith(
        failureOrSuccessOption: optionOf(failureOrUnit),
      ));
    }

    emit(await failureOrMessage.fold(
      (f) async => state.copyWith(
        isSubmitting: false,
        failureOrSuccessOption: optionOf(failureOrUnit),
      ),
      (message) async {
        if (message.type.isText) {
          return MessageFormState.initial().copyWith(
            failureOrSuccessOption: optionOf(failureOrUnit),
          );
        }

        //updload image
        final failureOrImageUrl = await _uploadImage.call(
          UploadImageParams(imageFile!),
        );

        //change right value to unit.
        failureOrUnit = failureOrImageUrl.map((r) => unit);

        return await failureOrImageUrl.fold(
          (f) async => state.copyWith(
              isSubmitting: false,
              failureOrSuccessOption: optionOf(failureOrUnit)),
          (imageUrl) async {
            // update message with imageUrl.
            final newMessage = message.copyWith(imageUrl: imageUrl);

            // update to server
            await _editMessage.call(EditMessageParams(
              roomId: event.roomId,
              message: newMessage,
            ));

            return MessageFormState.initial().copyWith(
              failureOrSuccessOption: optionOf(failureOrUnit),
            );
          },
        );
      },
    ));
  }
}
