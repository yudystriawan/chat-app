import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_actor/account_actor_bloc.dart';
import 'package:chat_app/features/account/presentation/dialogs/show_confirmation_delete.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/app_bar.dart';

@RoutePage()
class AccountPage extends StatelessWidget implements AutoRouteWrapper {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AccountActorBloc, AccountActorState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          accountRemoved: (_) =>
              context.read<AuthBloc>().add(const AuthEvent.signOut()),
        );
      },
      child: Scaffold(
        appBar: const MyAppBar(
          title: Text('Account'),
        ),
        body: const SizedBox(),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: BlocBuilder<AccountActorBloc, AccountActorState>(
              builder: (context, state) {
                return state.maybeMap(
                  actionInProgress: (_) => const CircularProgressIndicator(),
                  orElse: () => SecondaryButton.error(
                    onPressed: () async {
                      var accountId = context.read<AuthBloc>().state.user.id;
                      return showConfirmationDeleteDialog(context)
                          .then((result) {
                        if (result == null || !result) return;
                        return context
                            .read<AccountActorBloc>()
                            .add(AccountActorEvent.accountRemoved(accountId));
                      });
                    },
                    child: const Text('Delete this account!'),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AccountActorBloc>(),
      child: this,
    );
  }
}
