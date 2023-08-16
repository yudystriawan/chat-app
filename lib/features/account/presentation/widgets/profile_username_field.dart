import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

class ProfileUsernameField extends HookWidget {
  const ProfileUsernameField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<ProfileFormBloc>().state.account.username,
    );
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.account.username != c.account.username,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          placeholder: 'Username (required)',
          onChange: (value) => context
              .read<ProfileFormBloc>()
              .add(ProfileFormEvent.usernameChanged(value)),
          validator: (value) =>
              (value?.isEmpty ?? false) ? 'Tidak boleh kosong' : null,
        );
      },
    );
  }
}
