import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

import '../../../../../utils/errors/failure.dart';
import '../../../../../utils/usecases/usecase.dart';
import '../../../domain/usecases/login_with_google.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

@injectable
class SignInFormBloc extends Bloc<SignInFormEvent, SignInFormState> {
  final LoginWithGoogle _loginWithGoogle;
  SignInFormBloc(
    this._loginWithGoogle,
  ) : super(SignInFormState.initial()) {
    on<_SignInWithGooglePressed>(_onSignInWithGooglePressed);
  }

  void _onSignInWithGooglePressed(
    _SignInWithGooglePressed event,
    Emitter<SignInFormState> emit,
  ) async {
    emit(state.copyWith(
      isSubmitting: true,
      failureOrSuccessOption: none(),
    ));

    final failureOrSuccess = await _loginWithGoogle(const NoParams());

    emit(state.copyWith(
      isSubmitting: false,
      failureOrSuccessOption: optionOf(failureOrSuccess),
    ));
  }
}
