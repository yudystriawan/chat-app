import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/profile_form/profile_form_bloc.dart';
import 'profile_avatar.dart';
import 'profile_bio_field.dart';
import 'profile_email_field.dart';
import 'profile_name_field.dart';
import 'profile_phone_number_field.dart';
import 'profile_username_field.dart';

class ProfileFormWidget extends StatelessWidget {
  const ProfileFormWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileFormBloc, ProfileFormState>(
      buildWhen: (p, c) => p.showErrorMessages != c.showErrorMessages,
      builder: (context, state) {
        return Form(
          autovalidateMode: state.showErrorMessages
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              46.verticalSpace,
              const ProfileAvatar(),
              32.verticalSpace,
              const ProfileUsernameField(),
              12.verticalSpace,
              const ProfileBioField(),
              12.verticalSpace,
              const ProfileNameField(),
              12.verticalSpace,
              const ProfileEmailField(),
              12.verticalSpace,
              const ProfilePhoneNumberField(),
            ],
          ),
        );
      },
    );
  }
}
