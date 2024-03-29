import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final Widget? leading;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (BuildContext context) {
          final canPop = context.router.canPop();

          return Container(
            color: NeutralColor.white,
            padding: EdgeInsets.symmetric(vertical: 13.w, horizontal: 16.w),
            constraints: BoxConstraints(minHeight: 30.w),
            child: Row(
              children: [
                if (canPop) ...[
                  GestureDetector(
                    onTap: () => context.router.pop(),
                    child: SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: leading ??
                          Icon(
                            Coolicons.chevron_left,
                            size: 24.w,
                          ),
                    ),
                  ),
                  8.horizontalSpace,
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: AppTypography.subHeading1,
                        child: title,
                      ),
                      if (subtitle != null) ...[
                        DefaultTextStyle(
                          style: AppTypography.bodyText2,
                          child: subtitle!,
                        ),
                      ]
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  8.horizontalSpace,
                  trailing!,
                ]
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(30.w + 26.w);
}
