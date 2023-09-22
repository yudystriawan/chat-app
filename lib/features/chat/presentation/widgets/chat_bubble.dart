import 'package:coolicons/coolicons.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    Key? key,
    this.isSender = true,
    this.isRead = false,
    required this.body,
    this.sentAt,
    this.imageUrl,
    this.recipientName,
  })  : assert(!isSender || recipientName == null,
            "Sender does not need recipient's name"),
        assert(!isRead || recipientName == null,
            "Receipient does not need read info"),
        super(key: key);

  final bool isSender;
  final bool isRead;
  final Widget body;
  final DateTime? sentAt;
  final String? imageUrl;
  final String? recipientName;

  @override
  Widget build(BuildContext context) {
    final bubbleBackground = isSender ? BrandColor.neutral : NeutralColor.white;
    final textColor = isSender ? NeutralColor.white : NeutralColor.active;
    final metadataColor = isSender ? NeutralColor.white : NeutralColor.disabled;

    Widget body = this.body;

    if (body is Text) {
      if (body.data?.isEmpty ?? false) {
        body = const SizedBox();
      } else {
        body = DefaultTextStyle(
          style:
              body.style ?? AppTypography.bodyText2.copyWith(color: textColor),
          child: Text(body.data!),
        );
      }
    }

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.w),
        constraints: BoxConstraints(maxWidth: 317.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
            bottomLeft: isSender ? Radius.circular(16.r) : Radius.zero,
            bottomRight: isSender ? Radius.zero : Radius.circular(16.r),
          ),
          color: bubbleBackground,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (recipientName != null) ...[
              Text(
                recipientName!,
                style: AppTypography.metadata3.copyWith(color: BrandColor.dark),
              ),
              const SizedBox(height: 4),
            ],
            if (imageUrl != null && imageUrl!.isNotEmpty) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: SizedBox(
                  height: 218.w,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ] else
              Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: NeutralColor.weak,
                ),
                child: Icon(
                  Coolicons.image,
                  size: 24.w,
                ),
              ),
            const SizedBox(height: 4),
            body,
            SizedBox(height: 4.w),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment:
                  isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                if (sentAt != null)
                  Text(
                    sentAt!.toStringFormatted('HH:mm'),
                    style:
                        AppTypography.metadata2.copyWith(color: metadataColor),
                  ),
                if (isRead) ...[
                  Text(
                    ' • ',
                    style:
                        AppTypography.metadata2.copyWith(color: metadataColor),
                  ),
                  Text(
                    'Read',
                    style:
                        AppTypography.metadata2.copyWith(color: metadataColor),
                  )
                ]
              ],
            )
          ],
        ),
      ),
    );
  }
}
