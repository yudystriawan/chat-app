import 'package:auto_route/auto_route.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<bool?> showConfirmationDeleteDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actions: [
          GhostButton.error(
            onPressed: () => context.popRoute(true),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: const Text('Delete'),
          ),
          PrimaryButton(
            onPressed: () => context.popRoute(false),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: const Text('Cancel'),
          ),
        ],
        content: Text(
          'Please be aware that deleting your account is an irreversible action, meaning all data associated with your account will be permanently removed and cannot be recovered',
          style: AppTypography.bodyText1,
        ),
      );
    },
  );
}
