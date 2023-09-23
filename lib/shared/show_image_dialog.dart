import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showImageDialog(
  BuildContext context, {
  required String imageUrl,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      insetPadding: EdgeInsets.all(12.w),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GhostButton(
              onPressed: () => context.popRoute(),
              backgroundColor: NeutralColor.offWhite,
              padding: EdgeInsets.all(4.w),
              child: const Icon(Coolicons.close_big),
            ),
          ),
          8.verticalSpace,
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: NeutralColor.secondaryBG,
            ),
            child: Hero(
              tag: imageUrl,
              child: CachedNetworkImage(imageUrl: imageUrl),
            ),
          ),
        ],
      ),
    ),
  );
}
