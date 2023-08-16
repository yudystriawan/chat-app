import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

class ProfileEmailField extends HookWidget {
  const ProfileEmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<ProfileFormBloc>().state.account.email,
    );
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.account.email != c.account.email,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          placeholder: 'Email (required)',
        );
      },
    );
  }
}
