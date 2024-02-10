import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';
import '../typography.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
  }) : super(key: key);

  final VoidCallback? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;

  factory GhostButton.error({
    Key? key,
    required VoidCallback? onPressed,
    required Widget? child,
    EdgeInsetsGeometry? padding,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
  }) {
    return GhostButton(
      key: key,
      onPressed: onPressed,
      backgroundColor: backgroundColor,
      padding: padding,
      foregroundColor: AccentColor.danger,
      borderRadius: borderRadius,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;

    final defaultTextStyle = AppTypography.subHeading2.copyWith(
      color: (foregroundColor ?? BrandColor.neutral)
          .withOpacity(isDisabled ? 0.5 : 1),
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
