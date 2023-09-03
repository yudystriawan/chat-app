import 'package:chat_app/features/account/presentation/blocs/profile_form/profile_form_bloc.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends HookWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final photoUrl = useState(
      context.read<ProfileFormBloc>().state.account.photoUrl,
    );
    final photoUrlIsEmpty = photoUrl.value.isEmpty;
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          padding: photoUrlIsEmpty ? EdgeInsets.all(22.w) : EdgeInsets.zero,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NeutralColor.offWhite,
            image: photoUrlIsEmpty
                ? null
                : DecorationImage(
                    image: NetworkImage(photoUrl.value),
                    fit: BoxFit.cover,
                  ),
          ),
          child: photoUrlIsEmpty
              ? Icon(
                  Coolicons.user,
                  size: 56.w,
                )
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GhostButton(
            onPressed: () {},
            padding: EdgeInsets.all(2.w),
            child: Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1.w),
                color: NeutralColor.offWhite,
              ),
              child: Center(
                child: Icon(
                  photoUrlIsEmpty ? Coolicons.plus : Coolicons.edit,
                  size: 21.w,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
