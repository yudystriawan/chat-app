import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';

class ProfileEmailField extends StatelessWidget {
  const ProfileEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField(
      placeholder: 'Email (required)',
      readOnly: true,
    );
  }
}
