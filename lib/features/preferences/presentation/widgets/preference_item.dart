import 'package:coolicons/coolicons.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreferenceItemWidget extends StatelessWidget {
  const PreferenceItemWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTapped,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTapped;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTapped,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.w),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24.w,
              ),
              6.horizontalSpace,
              Expanded(
                child: Text(
                  label,
                  style: AppTypography.bodyText1,
                ),
              ),
              Icon(
                Coolicons.chevron_right,
                size: 24.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
