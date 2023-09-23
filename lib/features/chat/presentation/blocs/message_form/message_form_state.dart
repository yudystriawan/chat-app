part of 'message_form_bloc.dart';

@freezed
class MessageFormState with _$MessageFormState {
  const factory MessageFormState({
    required String data,
    required MessageType messageType,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
    @Default(false) bool isSubmitting,
    File? imageFile,
    Message? replyMessage,
  }) = _MessageFormState;

  factory MessageFormState.initial() => MessageFormState(
        data: '',
        failureOrSuccessOption: none(),
        messageType: MessageType.text,
      );
}
