import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    Key? key,
    this.imageUrl,
    this.isOnline = false,
    this.hasStory = false,
  }) : super(key: key);

  final String? imageUrl;
  final bool isOnline;
  final bool hasStory;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.w,
      height: 56.w,
      // color: hasStory ? null : NeutralColor.white,
      decoration: hasStory
          ? BoxDecoration(
              color: NeutralColor.white,
              border: Border.all(
                width: 2.w,
                color: BrandColor.light,
              ),
              borderRadius: BorderRadius.circular(16.r),
            )
          : null,
      child: Stack(
        children: [
          Center(
            child: Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                color: BrandColor.light,
                image: imageUrl == null
                    ? null
                    : DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          if (isOnline)
            Positioned(
              top: 2.w,
              right: 2.w,
              child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeutralColor.white,
                ),
                child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AccentColor.success,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
