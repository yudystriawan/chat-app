import 'package:auto_route/auto_route.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/routes.gr.dart';

@RoutePage()
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) async {
        await Future.delayed(const Duration(seconds: 3), () {
          context.router.replace(const HomeRoute());
        });
      },
      child: const Scaffold(
        body: Center(child: Text('Splash Screen')),
      ),
    );
  }
}
