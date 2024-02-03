import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.onNavPressed,
    this.activeIndex = 0,
  });

  final Function(int index) onNavPressed;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 27.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _AppBottomNavigationItemWidget(
            isActive: activeIndex == 0,
            onPressed: () => onNavPressed.call(0),
            icon: Coolicons.group,
            label: 'Contacts',
          ),
          _AppBottomNavigationItemWidget(
            isActive: activeIndex == 1,
            onPressed: () => onNavPressed.call(1),
            icon: Coolicons.message_circle,
            label: 'Chats',
          ),
          _AppBottomNavigationItemWidget(
            isActive: activeIndex == 2,
            onPressed: () => onNavPressed.call(2),
            icon: Coolicons.more_horizontal,
            label: 'More',
          ),
        ],
      ),
    );
  }
}

class _AppBottomNavigationItemWidget extends StatelessWidget {
  const _AppBottomNavigationItemWidget({
    required this.onPressed,
    this.isActive = false,
    required this.label,
    required this.icon,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GhostButton(
      onPressed: onPressed,
      padding: EdgeInsets.symmetric(
        horizontal: 13.w,
        vertical: 6.w,
      ),
      child: isActive
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: AppTypography.bodyText1,
                ),
                4.verticalSpace,
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: NeutralColor.active,
                  ),
                  width: 4.w,
                  height: 4.w,
                ),
              ],
            )
          : Icon(
              icon,
              size: 32.w,
            ),
    );
  }
}
