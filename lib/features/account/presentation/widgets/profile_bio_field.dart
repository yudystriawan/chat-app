import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

class ProfileBioField extends HookWidget {
  const ProfileBioField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<ProfileFormBloc>().state.account.bio,
    );
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.account.bio != c.account.bio,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          placeholder: 'Bio (optional)',
          onChange: (value) => context
              .read<ProfileFormBloc>()
              .add(ProfileFormEvent.bioChanged(value)),
        );
      },
    );
  }
}
