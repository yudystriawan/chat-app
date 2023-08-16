import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

class ProfileNameField extends HookWidget {
  const ProfileNameField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<ProfileFormBloc>().state.account.name,
    );
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.account.name != c.account.name,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          placeholder: 'Name (required)',
        );
      },
    );
  }
}
