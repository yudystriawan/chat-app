import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';

class ProfileNameField extends StatelessWidget {
  const ProfileNameField({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField(
      placeholder: 'Name (required)',
    );
  }
}
