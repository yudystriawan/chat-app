import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
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

    final defaultTextColor = BrandColor.neutral.withOpacity(
      isDisabled ? 0.5 : 1,
    );

    final defaultTextStyle =
        AppTypography.subHeading2.copyWith(color: defaultTextColor);

    Widget? child = this.child;
    if (child is Text) {
      child = Text(
        child.data!,
        textAlign: TextAlign.center,
        style:
            child.style?.copyWith(color: defaultTextColor) ?? defaultTextStyle,
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
        border: Border.all(
          color: BrandColor.neutral.withOpacity(isDisabled ? 0.5 : 1),
          width: 2.w,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(30.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(30.r),
          onTap: onPressed,
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(
                  vertical: 12.w,
                  horizontal: 48.w,
                ),
            child: child,
          ),
        ),
      ),
    );
  }
}
