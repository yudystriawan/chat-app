import 'package:chat_app/features/chat/presentation/blocs/member_watcher/member_watcher_bloc.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../blocs/messages_watcher/messages_watcher_bloc.dart';
import 'chat_bubble.dart';

class ChatsContainer extends StatelessWidget {
  const ChatsContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user.id;

    return BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
      builder: (context, state) {
        if (state.isLoading || state.members.isEmpty()) {
          return const Center(child: CircularProgressIndicator());
        }

        final recipient =
            state.members.filter((member) => member.id != userId).first();

        return BlocBuilder<MessagesWatcherBloc, MessagesWatcherState>(
          buildWhen: (p, c) => p.messages != c.messages,
          builder: (context, state) {
            final messages = state.messages;

            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (messages.isEmpty()) {
              return Center(
                child: Text(
                  'No Message',
                  style: AppTypography.bodyText1,
                ),
              );
            }

            final listGroupedByDate = messages.groupBy((message) {
              final sentAt = message.sentAt ?? DateTime.now();
              final dateTime = DateTime(sentAt.year, sentAt.month, sentAt.day);
              return dateTime;
            });

            return ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: listGroupedByDate.size,
              shrinkWrap: true,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                final date = listGroupedByDate.keys.elementAt(index);
                final items = listGroupedByDate[date];

                if (items == null || items.isEmpty()) {
                  return Center(
                    child: Text(
                      'No Message',
                      style: AppTypography.bodyText1,
                    ),
                  );
                }

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        SizedBox(width: 16.w),
                        Text(
                          date.toStringDate(),
                          style: AppTypography.metadata1.copyWith(
                            color: NeutralColor.disabled,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      reverse: true,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.size,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 12.w);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        final message = items[index];

                        var isSender = userId == message.sentBy;

                        // return const SizedBox();

                        return ChatBubble(
                          body: Text(message.data),
                          sentAt: message.sentAt,
                          isSender: isSender,
                          recipientName: isSender ? null : recipient.name,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }
}
