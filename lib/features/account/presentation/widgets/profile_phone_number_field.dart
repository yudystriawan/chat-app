import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

class ProfilePhoneNumberField extends HookWidget {
  const ProfilePhoneNumberField({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(
      text: context.read<ProfileFormBloc>().state.account.phoneNumber,
    );
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.account.phoneNumber != c.account.phoneNumber,
      builder: (context, state) {
        return AppTextField(
          controller: controller,
          placeholder: 'Phone number (required)',
          validator: (value) =>
              (value?.isEmpty ?? false) ? 'Tidak boleh kosong' : null,
          onChange: (value) => context
              .read<ProfileFormBloc>()
              .add(ProfileFormEvent.phoneNumberChanged(value)),
          keyboardType: TextInputType.number,
        );
      },
    );
  }
}
