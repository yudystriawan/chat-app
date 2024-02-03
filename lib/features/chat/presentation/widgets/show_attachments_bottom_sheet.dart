import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/images/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/bottom_sheet.dart';

enum AttachmentType {
  camera,
  gallery;

  bool get isCamera => this == AttachmentType.camera;
  bool get isGallery => this == AttachmentType.gallery;
}

extension AttachmentTypeX on AttachmentType {
  ImageOrigin toImageOrigin() {
    if (isCamera) return ImageOrigin.camera;
    return ImageOrigin.gallery;
  }
}

Future<AttachmentType?> showAttachmentsBottomSheet(BuildContext context) {
  return showAppBottomSheet(
    context,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _AttachmentItem(
            onPressed: () => context.popRoute(AttachmentType.camera),
            icon: Icon(
              Icons.camera_alt_outlined,
              size: 32.w,
            ),
            label: const Text('Camera'),
          ),
          _AttachmentItem(
            onPressed: () => context.popRoute(AttachmentType.gallery),
            icon: Icon(
              Coolicons.image,
              size: 32.w,
            ),
            label: const Text('Gallery'),
          ),
        ],
      )
    ],
  );
}

class _AttachmentItem extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;

  const _AttachmentItem({
    this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GhostButton(
          onPressed: onPressed,
          backgroundColor: BrandColor.background,
          padding: EdgeInsets.all(12.w),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: icon,
          ),
        ),
        DefaultTextStyle(
          style: AppTypography.metadata1.bold,
          child: label,
        )
      ],
    );
  }
}
