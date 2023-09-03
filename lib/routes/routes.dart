import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routes/guards/account_guard.dart';
import 'package:core/core.dart' as core;
import 'package:core/utils/routes/guards/auth_guard.dart';
import 'package:core/utils/routes/router.gm.dart';

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
          AccountGuard(),
        ],
        children: [
          AutoRoute(page: ContactsRoute.page, initial: true),
          AutoRoute(page: ChatRoute.page),
          AutoRoute(page: PreferencesRoute.page),
        ],
      ),
      AutoRoute(page: SignInRoute.page),
      AutoRoute(page: ProfileRoute.page),
      AutoRoute(page: AccountRoute.page),
      AutoRoute(page: AddContactRoute.page),
    ];
  }
}
