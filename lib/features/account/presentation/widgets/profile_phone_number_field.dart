import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';

class ProfilePhoneNumberField extends StatelessWidget {
  const ProfilePhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField(
      placeholder: 'Phone number (required)',
    );
  }
}
