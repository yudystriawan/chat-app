import 'package:chat_app/features/account/presentation/widgets/profile_avatar.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_bio_field.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_email_field.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_name_field.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_phone_number_field.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_username_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/profile_form/profile_form_bloc.dart';

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
              SizedBox(height: 46.w),
              const ProfileAvatar(),
              SizedBox(height: 32.w),
              const ProfileUsernameField(),
              SizedBox(height: 12.w),
              const ProfileBioField(),
              SizedBox(height: 12.w),
              const ProfileNameField(),
              SizedBox(height: 12.w),
              const ProfileEmailField(),
              SizedBox(height: 12.w),
              const ProfilePhoneNumberField(),
            ],
          ),
        );
      },
    );
  }
}
