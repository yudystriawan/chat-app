import 'package:auto_route/auto_route.dart';
import 'package:core/features/auth/presentation/widgets/terms_of_service.dart';
import 'package:core/styles/bottom_sheet/bottom_sheet.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:core/styles/image_render_widget.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageRender(
                'packages/core/assets/illustration.png',
                width: 262.w,
                height: 271.w,
              ),
              42.verticalSpaceFromWidth,
              Text(
                'Connect easily with your family and friends over countries',
                style: AppTypography.heading2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => showAppBottomSheet(
                  context,
                  children: [const TermsOfService()],
                ),
                child: Text(
                  'Terms & Privacy Policy',
                  style: AppTypography.bodyText1,
                ),
              ),
              18.verticalSpaceFromWidth,
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: PrimaryButton(
                  onPressed: () => context
                      .read<SignInFormBloc>()
                      .add(const SignInFormEvent.signInWithGooglePressed()),
                  child: const Text('Sign in with Google'),
                ),
              ),
            ],
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
