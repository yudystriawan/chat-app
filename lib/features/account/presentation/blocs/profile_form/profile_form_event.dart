part of 'profile_form_bloc.dart';

@freezed
class ProfileFormEvent with _$ProfileFormEvent {
  const factory ProfileFormEvent.usernameChanged(String username) =
      _UsernameChanged;
  const factory ProfileFormEvent.bioChanged(String bio) = _BioChanged;
  const factory ProfileFormEvent.nameChanged(String name) = _NameChanged;
  const factory ProfileFormEvent.emailChanged(String email) = _EmailChanged;
  const factory ProfileFormEvent.phoneNumberChanged(String phoneNumber) =
      _PhoneNumberChanged;
  const factory ProfileFormEvent.submitted() = _Submitted;
}
