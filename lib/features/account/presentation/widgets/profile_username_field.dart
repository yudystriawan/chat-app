import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';

class ProfileUsernameField extends StatelessWidget {
  const ProfileUsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField(
      placeholder: 'Username (required)',
    );
  }
}
