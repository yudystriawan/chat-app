import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart' as core;
import 'package:core/utils/routes/router.gm.dart';

import 'routes.gr.dart';

@AutoRouterConfig(
  modules: [core.CoreRouter],
)
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(
        page: HomeRoute.page,
      ),
      AutoRoute(page: SignInRoute.page, initial: true),
    ];
  }
}
