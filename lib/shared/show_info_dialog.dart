import 'package:auto_route/auto_route.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showInfoDialog(
  BuildContext context, {
  required String content,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.all(12.w),
        child: Padding(
          padding: const EdgeInsets.all(12.0).w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Information',
                style: AppTypography.subHeading1.bold,
              ),
              8.verticalSpaceFromWidth,
              Text(
                content,
                style: AppTypography.bodyText1,
                textAlign: TextAlign.justify,
              ),
              12.verticalSpaceFromWidth,
              Align(
                alignment: Alignment.bottomRight,
                child: GhostButton(
                  onPressed: () => context.popRoute(),
                  child: const Text('OK'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
