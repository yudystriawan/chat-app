import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliver_tools/sliver_tools.dart';

Future<T?> showAppBottomSheet<T>(
  BuildContext context, {
  Widget? title,
  List<Widget>? children,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height -
          MediaQueryData.fromView(View.of(context)).padding.top -
          kToolbarHeight,
    ),
    builder: (context) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        color: NeutralColor.offWhite,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 8.w,
        horizontal: 20.w,
      ).copyWith(
        bottom: MediaQuery.of(context).padding.bottom == 0
            ? 24.w
            : MediaQuery.of(context).padding.bottom,
      ),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: CustomScrollView(
          shrinkWrap: true,
          slivers: <Widget>[
            SliverPinnedHeader(
              child: Center(
                child: Container(
                  width: 80.w,
                  height: 4.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: NeutralColor.line,
                  ),
                ),
              ),
            ),
            SliverPinnedHeader(child: 24.verticalSpace),
            SliverToBoxAdapter(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) ...[
                    DefaultTextStyle(
                      style: AppTypography.heading2,
                      child: title,
                    ),
                    Divider(
                      height: 32.w,
                    ),
                  ],
                  if (children != null) ...children,
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
