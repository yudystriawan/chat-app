import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'routes/routes.gr.dart';

@RoutePage()
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2300), // Adjust duration as needed
    );

    // Create a fade-in animation
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Navigate to the next page after the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        context.router.replace(const HomeRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // this code is neccessary for triggering watch account
    context.watch<AccountWatcherBloc>();

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (p, c) => p.status != c.status,
      listener: (context, state) {
        // Start the animation
        if (!_controller.isAnimating) _controller.forward();
      },
      child: Scaffold(
        body: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  package: 'core',
                  width: 56.w,
                  height: 56.w,
                ),
                4.verticalSpaceFromWidth,
                Text(
                  'Chat App',
                  style: AppTypography.heading2.bold,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
