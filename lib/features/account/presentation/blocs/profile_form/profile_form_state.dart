part of 'profile_form_bloc.dart';

@freezed
class ProfileFormState with _$ProfileFormState {
  const factory ProfileFormState({
    required Account account,
    required Option<Either<Failure, Unit>> failureOrSuccessOption,
    @Default(false) bool isSubmitting,
    @Default(false) bool showErrorMessages,
  }) = _ProfileFormState;

  factory ProfileFormState.initial({Account? initialAccount}) {
    return ProfileFormState(
      account: initialAccount ?? Account.empty(),
      failureOrSuccessOption: none(),
    );
  }
}
