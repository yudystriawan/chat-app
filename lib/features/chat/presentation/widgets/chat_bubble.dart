import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../../../../shared/swipeable_widget.dart';
import '../../../account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import '../../domain/entities/entity.dart';
import '../blocs/member_watcher/member_watcher_bloc.dart';
import 'chat_image.dart';
import 'reply_chat_widget.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    this.onSwipeRight,
    this.onReplyTapped,
  });

  final Message message;
  final VoidCallback? onSwipeRight;
  final Function(String messageId)? onReplyTapped;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AccountWatcherBloc>().state.account.id;
    final sentByMyself = userId == message.sentBy;

    // get read status that not from message sender itself
    final readBy = message.readBy.filter(
      (entry) => entry.value && entry.key != userId,
    );
    final isRead = readBy.isNotEmpty();

    final bubbleBackground =
        sentByMyself ? BrandColor.neutral : NeutralColor.white;
    final textColor = sentByMyself ? NeutralColor.white : NeutralColor.active;
    final metadataColor =
        sentByMyself ? NeutralColor.white : NeutralColor.disabled;

    return BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
      buildWhen: (p, c) => p.members != c.members,
      builder: (context, state) {
        if (state.isLoading || state.members.isEmpty()) {
          return const Center(child: CircularProgressIndicator());
        }

        // get member room exclude myself
        final recipients =
            state.members.filter((member) => member.id != userId);

        // get the sender name
        final recipientName = recipients
            .firstOrNull((member) => member.id == message.sentBy)
            ?.name;

        return SwipeableWidget(
          onSwipeRight: onSwipeRight,
          child: Align(
            alignment:
                sentByMyself ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.all(10.w),
              constraints: BoxConstraints(maxWidth: 317.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.r),
                  topRight: Radius.circular(16.r),
                  bottomLeft:
                      sentByMyself ? Radius.circular(16.r) : Radius.zero,
                  bottomRight:
                      sentByMyself ? Radius.zero : Radius.circular(16.r),
                ),
                color: bubbleBackground,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: sentByMyself
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (recipientName != null) ...[
                    Text(
                      recipientName,
                      style: AppTypography.metadata3
                          .copyWith(color: BrandColor.dark),
                    ),
                    4.verticalSpace,
                  ],
                  if (message.replyMessage != null) ...[
                    ReplyChatWidget(
                      message: message.replyMessage!,
                      sentByMyself: sentByMyself,
                      isReplyFromMyself: message.isReplyFromMyself,
                      onTap: onReplyTapped,
                    ),
                    4.verticalSpace,
                  ],
                  ChatImageNetwork(imageUrl: message.imageUrl),
                  4.verticalSpace,
                  Text(
                    message.data,
                    style: AppTypography.bodyText2.copyWith(
                      color: textColor,
                    ),
                  ),
                  4.verticalSpace,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: sentByMyself
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      if (message.sentAt != null)
                        Text(
                          message.sentAt!.toStringFormatted('HH:mm'),
                          style: AppTypography.metadata2
                              .copyWith(color: metadataColor),
                        ),
                      if (isRead)
                        Text(
                          ' • Read',
                          style: AppTypography.metadata2
                              .copyWith(color: metadataColor),
                        ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
