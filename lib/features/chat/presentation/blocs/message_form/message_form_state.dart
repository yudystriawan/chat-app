part of 'message_form_bloc.dart';

@freezed
class MessageFormState with _$MessageFormState {
  const factory MessageFormState({
    required String data,
    required MessageType type,
    @Default(false) bool isSubmitting,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
  }) = _MessageFormState;

  factory MessageFormState.initial() => MessageFormState(
        data: '',
        type: MessageType.text,
        failureOrSuccessOption: none(),
      );
}
