import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpirationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context == null) return;

    final account = context.read<AccountWatcherBloc>().state.account;

    final currentTime = DateTime.now();
    final expirationTime = account.expiredAt;

    if (account.expiredAt != null && currentTime.isAfter(expirationTime!)) {
      resolver.redirect(const AccountExpiredRoute());
      return;
    }

    return resolver.next();
  }
}
