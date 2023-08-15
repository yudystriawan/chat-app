import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100.w,
          height: 100.w,
          padding: EdgeInsets.all(22.w),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: NeutralColor.offWhite,
          ),
          child: Icon(
            Coolicons.user,
            size: 56.w,
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GhostButton(
            onPressed: () {},
            child: Icon(
              Coolicons.plus_circle,
              size: 24.w,
            ),
          ),
        ),
      ],
    );
  }
}
