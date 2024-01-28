import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/auth/presentation/blocs/auth/auth_bloc.dart';
import '../router.gm.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context != null) {
      final isAuthenticated = context.read<AuthBloc>().state.isAuthenticated;

      if (isAuthenticated) {
        resolver.next();
        return;
      }

      resolver.redirect(
        SignInRoute(onResult: (didLogin) {
          if (resolver.pendingRoutes.isEmpty) {
            resolver.resolveNext(didLogin, reevaluateNext: false);
            return;
          }

          router.replaceNamed('/home-route');
          resolver.next(false);
        }),
        replace: true,
      );
    }
  }
}
