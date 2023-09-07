import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'colors.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onChange,
    this.autoFocus = false,
    this.readOnly = false,
    this.placeholder,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.prefixIcon,
  }) : super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Function(String value)? onChange;
  final bool autoFocus;
  final bool readOnly;
  final String? placeholder;
  final String? Function(String? value)? validator;
  final Function(String value)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: _focusNode,
      autofocus: widget.autoFocus,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      style: AppTypography.bodyText1.copyWith(
        color: widget.readOnly ? NeutralColor.disabled : null,
        height: 1,
      ),
      cursorHeight: AppTypography.bodyText1.fontSize,
      cursorColor: BrandColor.dark,
      decoration: InputDecoration(
        hintText: widget.placeholder ?? 'Placeholder',
        prefixIcon: widget.prefixIcon,
        prefixIconColor:
            _focusNode.hasFocus ? NeutralColor.active : NeutralColor.disabled,
        hintStyle: AppTypography.bodyText1.copyWith(
          color: NeutralColor.disabled,
          height: 1,
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
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AccentColor.danger,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AccentColor.danger,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        errorStyle: AppTypography.metadata2.copyWith(
          color: AccentColor.danger,
        ),
      ),
      onChanged: widget.onChange,
      onFieldSubmitted: widget.onFieldSubmitted,
      validator: widget.validator,
    );
  }
}
