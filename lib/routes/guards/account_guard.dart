import 'package:auto_route/auto_route.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/account/domain/entities/account.dart';
import '../routes.gr.dart';

class AccountGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final context = router.navigatorKey.currentContext;

    if (context != null) {
      final user = context.read<AuthBloc>().state.user;

      if (user.username.isNotEmpty) {
        resolver.next();
        return;
      }

      final account = Account.fromUser(user);

      resolver.redirect(ProfileRoute(
        initialAccount: account,
        onResult: (isSuccess) => resolver.next(isSuccess),
      ));
    }
  }
}
