import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';
import 'typography.dart';

class AppBadge extends StatelessWidget {
  const AppBadge({
    Key? key,
    this.count,
  }) : super(key: key);

  final int? count;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40.r),
        color: BrandColor.background,
      ),
      child: count == null
          ? null
          : Center(
              child: Text(
                count.toString(),
                textAlign: TextAlign.center,
                style: AppTypography.metadata3.copyWith(
                  color: BrandColor.dark,
                ),
              ),
            ),
    );
  }
}
