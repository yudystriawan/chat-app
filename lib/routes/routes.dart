import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routes/guards/expiration_guard.dart';
import 'package:core/core.dart' as core;
import 'package:core/utils/routes/guards/auth_guard.dart';
import 'package:core/utils/routes/router.gm.dart';

import 'guards/account_guard.dart';
import 'routes.gr.dart';

@AutoRouterConfig(
  modules: [core.CoreRouter],
)
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: SplashRoute.page, initial: true),
      AutoRoute(
        page: HomeRoute.page,
        guards: [
          AuthGuard(),
          ExpirationGuard(),
          AccountGuard(),
        ],
        children: [
          AutoRoute(page: ContactsRoute.page, initial: true),
          AutoRoute(page: ChatRoute.page),
          AutoRoute(page: PreferencesRoute.page),
        ],
      ),
      AutoRoute(page: SignInRoute.page),
      AutoRoute(
        page: ProfileRoute.page,
        guards: [ExpirationGuard()],
      ),
      AutoRoute(
        page: AccountRoute.page,
        guards: [ExpirationGuard()],
      ),
      AutoRoute(
        page: AddContactRoute.page,
        guards: [ExpirationGuard()],
      ),
      AutoRoute(
        page: RoomRoute.page,
        guards: [ExpirationGuard()],
      ),
      AutoRoute(page: AccountExpiredRoute.page)
    ];
  }
}
