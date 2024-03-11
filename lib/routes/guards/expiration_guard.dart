import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:core/utils/routes/router.gm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExpirationGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context == null) return;

    final account = context.read<AccountWatcherBloc>().state.account;

    final currentTime = DateTime.now();
    final expirationTime = account.expiredAt;

    if (account.expiredAt != null && currentTime.isBefore(expirationTime!)) {
      resolver.redirect(AccountExpiredRoute(
        onAccountRemoved: (isAccountRemoved) {
          if (isAccountRemoved) {
            resolver.redirect(SignInRoute(onResult: (didLogin) {
              resolver.redirect(const HomeRoute());
            }), replace: true);
          }
        },
      ));
      return;
    }

    return resolver.next();
  }
}
