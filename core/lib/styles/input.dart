import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChange,
    this.autoFocus = false,
    this.readOnly = false,
    this.placeholder,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String value)? onChange;
  final bool autoFocus;
  final bool readOnly;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autoFocus,
      readOnly: readOnly,
      style: AppTypography.bodyText1.copyWith(
        color: readOnly ? NeutralColor.disabled : null,
      ),
      cursorColor: BrandColor.dark,
      decoration: InputDecoration(
        hintText: placeholder ?? 'Placeholder',
        hintStyle: AppTypography.bodyText1.copyWith(
          color: NeutralColor.disabled,
        ),
        fillColor: NeutralColor.offWhite,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(4.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 6.w,
          horizontal: 8.w,
        ),
        filled: true,
      ),
      onChanged: onChange,
    );
  }
}
