import 'package:auto_route/auto_route.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/di/injection.dart';
import '../blocs/sign_in_form/sign_in_form_bloc.dart';

@RoutePage()
class SignInPage extends StatelessWidget implements AutoRouteWrapper {
  const SignInPage({
    Key? key,
    this.onResult,
  }) : super(key: key);

  final Function(bool didLogin)? onResult;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignInFormBloc, SignInFormState>(
          listenWhen: (p, c) =>
              p.failureOrSuccessOption != c.failureOrSuccessOption,
          listener: (context, state) {
            state.failureOrSuccessOption.fold(
              () => null,
              (either) => either.fold(
                (l) {
                  // show something
                },
                (_) {
                  // show snackbar
                },
              ),
            );
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (p, c) => p.isAuthenticated != c.isAuthenticated,
          listener: (context, state) {
            if (state.isAuthenticated) onResult?.call(true);
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () => context
                .read<SignInFormBloc>()
                .add(const SignInFormEvent.signInWithGooglePressed()),
            child: const Text('Sign in with Google'),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => getIt<SignInFormBloc>(),
        child: this,
      );
}
