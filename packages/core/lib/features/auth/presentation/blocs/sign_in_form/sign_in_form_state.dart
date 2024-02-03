part of 'sign_in_form_bloc.dart';

@freezed
class SignInFormState with _$SignInFormState {
  const factory SignInFormState({
    required Option<Either<Failure, User>> failureOrUserOption,
    @Default(false) isSubmitting,
  }) = _SignInFormState;

  factory SignInFormState.initial() =>
      SignInFormState(failureOrUserOption: none());
}
