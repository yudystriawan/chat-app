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
    this.backgroundColor,
    this.borderRadius,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    final defaultTextStyle = AppTypography.subHeading2.copyWith(
      color: BrandColor.neutral.withOpacity(isDisabled ? 0.5 : 1),
    );

    final defaultBorderRadius = BorderRadius.circular(30.r);

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

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? defaultBorderRadius,
        color: backgroundColor,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? defaultBorderRadius,
        child: InkWell(
          borderRadius: borderRadius ?? defaultBorderRadius,
          onTap: onPressed,
          child: Padding(
            padding: defaultPadding,
            child: child,
          ),
        ),
      ),
    );
  }
}
