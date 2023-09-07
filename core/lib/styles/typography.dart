import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const textTheme = GoogleFonts.mulishTextTheme;

class AppTypography {
  static TextStyle get heading1 {
    return TextStyle(
      fontSize: 32.sp,
      fontWeight: FontWeight.w700,
      color: NeutralColor.active,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get heading2 {
    return TextStyle(
      fontSize: 24.sp,
      fontWeight: FontWeight.w700,
      color: NeutralColor.active,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get subHeading1 {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 30.sp / 18.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get subHeading2 {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 28.sp / 16.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get bodyText1 {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 24.sp / 14.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get bodyText2 {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 24.sp / 14.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata1 {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 20.sp / 12.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata2 {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      color: NeutralColor.active,
      height: 16.sp / 10.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }

  static TextStyle get metadata3 {
    return TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w600,
      color: NeutralColor.active,
      height: 16.sp / 10.sp,
      leadingDistribution: TextLeadingDistribution.even,
    );
  }
}

extension TextStyleX on TextStyle {
  TextStyle get bold {
    return copyWith(fontWeight: FontWeight.w600);
  }
}
