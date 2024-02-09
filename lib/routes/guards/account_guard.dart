import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../routes.gr.dart';

class AccountGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context != null) {
      final account = context.read<AccountWatcherBloc>().state.account;

      if (account.username.isNotEmpty) {
        resolver.next();
        return;
      }

      resolver.redirect(ProfileRoute(
        initialAccount: account,
        onResult: (isSuccess) => resolver.next(isSuccess),
      ));
    }
  }
}
