import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../styles/buttons/primary_button.dart';
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
          listenWhen: (p, c) => p.failureOrUserOption != c.failureOrUserOption,
          listener: (context, state) {
            state.failureOrUserOption.fold(
              () => null,
              (either) => either.fold(
                (l) {
                  // show something
                },
                (_) {
                  onResult?.call(true);
                },
              ),
            );
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: PrimaryButton(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.w),
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
