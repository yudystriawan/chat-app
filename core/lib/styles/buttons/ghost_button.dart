import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    final defaultTextStyle = AppTypography.subHeading2.copyWith(
      color: BrandColor.neutral.withOpacity(isDisabled ? 0.5 : 1),
    );

    EdgeInsetsGeometry defaultPadding = EdgeInsets.symmetric(
      vertical: 12.w,
      horizontal: 30.w,
    );

    Widget? child = this.child;
    if (child is Text) {
      child = Text(
        child.data!,
        style: defaultTextStyle,
        textAlign: TextAlign.center,
      );
    }

    if (child is Icon) {
      defaultPadding = EdgeInsets.all(2.w);
    }

    if (padding != null) defaultPadding = padding!;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(30.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(30.r),
        onTap: onPressed,
        child: Padding(
          padding: defaultPadding,
          child: child,
        ),
      ),
    );
  }
}
