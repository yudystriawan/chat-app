import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';

class ProfileBioField extends StatelessWidget {
  const ProfileBioField({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTextField(
      placeholder: 'Bio (optional)',
    );
  }
}
