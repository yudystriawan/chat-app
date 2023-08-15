import 'package:auto_route/auto_route.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/utils/routes/router.gm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context != null) {
      final authProvider = context.read<AuthBloc>().state.isAuthenticated;

      if (authProvider) {
        resolver.next();
        return;
      }

      resolver.redirect(SignInRoute(
        onResult: (didLogin) =>
            resolver.resolveNext(didLogin, reevaluateNext: false),
      ));
    }
  }
}
