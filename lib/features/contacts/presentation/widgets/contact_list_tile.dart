import 'package:core/styles/avatar.dart';
import 'package:core/styles/badge.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactListTile extends StatelessWidget {
  const ContactListTile({
    Key? key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.date,
    this.isOnline = false,
    this.hasStory = false,
    this.chatCount,
    this.trailing,
  }) : super(key: key);

  final Widget title;
  final Widget? subtitle;
  final String? imageUrl;
  final String? date;
  final bool isOnline;
  final bool hasStory;
  final int? chatCount;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    var subtitle = this.subtitle;
    if (isOnline && subtitle == null) {
      subtitle = const Text('Online');
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Avatar(
          imageUrl: imageUrl ?? 'http://via.placeholder.com/640x640',
          hasStory: hasStory,
          isOnline: isOnline,
        ),
        SizedBox(
          width: 12.w,
        ),
        Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: DefaultTextStyle(
                      style: AppTypography.bodyText1,
                      child: title,
                    ),
                  ),
                  if (date != null) ...[
                    SizedBox(width: 2.w),
                    Text(
                      date!,
                      style: AppTypography.metadata2.copyWith(
                        color: NeutralColor.weak,
                      ),
                    ),
                  ]
                ],
              ),
              if (subtitle != null) ...[
                SizedBox(
                  height: 2.w,
                ),
                Row(
                  children: [
                    Expanded(
                      child: DefaultTextStyle(
                        style: AppTypography.metadata1.copyWith(
                          color: NeutralColor.disabled,
                        ),
                        child: subtitle,
                      ),
                    ),
                    if (chatCount != null) ...[
                      SizedBox(width: 2.w),
                      AppBadge(count: chatCount),
                    ]
                  ],
                ),
              ]
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: 8.w),
          trailing!,
        ],
      ],
    );
  }
}
