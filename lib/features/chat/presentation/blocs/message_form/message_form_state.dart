part of 'message_form_bloc.dart';

@freezed
class MessageFormState with _$MessageFormState {
  const factory MessageFormState({
    required String data,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
    @Default(false) bool isSubmitting,
    File? imageFile,
  }) = _MessageFormState;

  factory MessageFormState.initial() => MessageFormState(
        data: '',
        failureOrSuccessOption: none(),
      );
}
