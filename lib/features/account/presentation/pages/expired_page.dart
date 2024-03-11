import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_actor/account_actor_bloc.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class AccountExpiredPage extends StatelessWidget implements AutoRouteWrapper {
  const AccountExpiredPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountActorBloc, AccountActorState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          accountRemoved: (_) {
            context.read<AuthBloc>().add(const AuthEvent.signOut());
            context.router.replaceAll([const HomeRoute()]);
          },
        );
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12).w,
              child: Column(
                children: [
                  Icon(
                    Coolicons.warning_outline,
                    size: 100.w,
                    color: AccentColor.danger,
                  ),
                  Text(
                    'Account Expired',
                    style: AppTypography.subHeading1.bold,
                  ),
                  12.verticalSpaceFromWidth,
                  Text(
                    "We regret to inform you that your account has expired, and as a result, you are unable to perform any further actions in the app.",
                    style: AppTypography.bodyText1,
                  ),
                  12.verticalSpaceFromWidth,
                  Text(
                    "Please note that this is a demo version of our app, and accounts are automatically deactivated after a designated period. We encourage you to explore the features of our app while your account is active.",
                    style: AppTypography.bodyText1,
                  ),
                  45.verticalSpaceFromWidth,
                  Text(
                    'Thank you for choosing our app for your demo needs.',
                    style: AppTypography.bodyText1,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.w, horizontal: 12.w),
            child: PrimaryButton(
              onPressed: () => context.read<AccountActorBloc>().add(
                  AccountActorEvent.accountRemoved(
                      context.read<AuthBloc>().state.user.id)),
              child: const Text('Sign Out'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) => BlocProvider(
        create: (context) => getIt<AccountActorBloc>(),
        child: this,
      );
}
