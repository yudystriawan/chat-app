import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  static final TextStyle _defaultTextStyle = GoogleFonts.mulish();

  static TextTheme setTextTheme([TextTheme? textTheme]) =>
      GoogleFonts.mulishTextTheme(textTheme);

  static TextStyle get heading1 {
    return _defaultTextStyle.copyWith(
      fontSize: 32.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w700,
      color: NeutralColor.active,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get heading2 {
    return _defaultTextStyle.copyWith(
      fontSize: 24.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w700,
      color: NeutralColor.active,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get subHeading1 {
    return _defaultTextStyle.copyWith(
      fontSize: 18.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 30.sp / 18.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get subHeading2 {
    return _defaultTextStyle.copyWith(
      fontSize: 16.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 28.sp / 16.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get bodyText1 {
    return _defaultTextStyle.copyWith(
      fontSize: 14.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 24.sp / 14.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get bodyText2 {
    return _defaultTextStyle.copyWith(
      fontSize: 14.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 24.sp / 14.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata1 {
    return _defaultTextStyle.copyWith(
      fontSize: 12.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 20.sp / 12.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata2 {
    return _defaultTextStyle.copyWith(
      fontSize: 10.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 16.sp / 10.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata3 {
    return _defaultTextStyle.copyWith(
      fontSize: 10.sp,
      fontFamily: _defaultTextStyle.fontFamilyFallback?.first,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 16.sp / 10.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}

extension TextStyleX on TextStyle {
  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.w700);
  }
}
