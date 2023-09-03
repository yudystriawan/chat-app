import 'package:bloc/bloc.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/usecases/save_account.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'profile_form_bloc.freezed.dart';
part 'profile_form_event.dart';
part 'profile_form_state.dart';

@injectable
class ProfileFormBloc extends Bloc<ProfileFormEvent, ProfileFormState> {
  final SaveAccount _saveAccount;
  ProfileFormBloc(
    @factoryParam Account? initialAccount,
    this._saveAccount,
  ) : super(ProfileFormState.initial(initialAccount: initialAccount)) {
    on<_UsernameChanged>(_onUsernameChanged);
    on<_BioChanged>(_onBioChanged);
    on<_NameChanged>(_onNameChanged);
    on<_EmailChanged>(_onEmailChanged);
    on<_PhoneNumberChanged>(_onPhoneNumberChanged);
    on<_Submitted>(_onSubmitted);
  }

  void _onUsernameChanged(
    _UsernameChanged event,
    Emitter<ProfileFormState> emit,
  ) async {
    final editedAccount = state.account.copyWith(username: event.username);
    emit(state.copyWith(
      account: editedAccount,
      failureOrSuccessOption: none(),
    ));
  }

  void _onBioChanged(
    _BioChanged event,
    Emitter<ProfileFormState> emit,
  ) async {
    final editedAccount = state.account.copyWith(bio: event.bio);
    emit(state.copyWith(
      account: editedAccount,
      failureOrSuccessOption: none(),
    ));
  }

  void _onNameChanged(
    _NameChanged event,
    Emitter<ProfileFormState> emit,
  ) async {
    final editedAccount = state.account.copyWith(name: event.name);
    emit(state.copyWith(
      account: editedAccount,
      failureOrSuccessOption: none(),
    ));
  }

  void _onEmailChanged(
    _EmailChanged event,
    Emitter<ProfileFormState> emit,
  ) async {
    final editedAccount = state.account.copyWith(email: event.email);
    emit(state.copyWith(
      account: editedAccount,
      failureOrSuccessOption: none(),
    ));
  }

  void _onPhoneNumberChanged(
    _PhoneNumberChanged event,
    Emitter<ProfileFormState> emit,
  ) async {
    final editedAccount =
        state.account.copyWith(phoneNumber: event.phoneNumber);
    emit(state.copyWith(
      account: editedAccount,
      failureOrSuccessOption: none(),
    ));
  }

  void _onSubmitted(
    _Submitted event,
    Emitter<ProfileFormState> emit,
  ) async {
    Either<Failure, Unit>? failureOrSuccess;
    emit(state.copyWith(
      showErrorMessages: true,
      isSubmitting: true,
    ));

    if (state.account.isValid) {
      failureOrSuccess = await _saveAccount(
        SaveAccountParams(account: state.account),
      );
    }

    emit(state.copyWith(
      isSubmitting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
