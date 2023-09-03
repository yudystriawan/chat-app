import 'package:auto_route/auto_route.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Account'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthEvent.signOut()),
          child: const Text('Sign Out'),
        ),
      ),
    );
  }
}
