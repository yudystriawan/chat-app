import 'package:auto_route/auto_route.dart';
import 'package:chat_app/routes/routes.gr.dart';

@AutoRouterConfig()
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes {
    return [
      AutoRoute(page: HomeRoute.page, initial: true),
    ];
  }
}
