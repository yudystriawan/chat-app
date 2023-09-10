import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/messages_watcher/messages_watcher_bloc.dart';
import 'chat_bubble.dart';

class ChatsContainer extends StatelessWidget {
  const ChatsContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          reverse: true,
          itemCount: messages.size,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(height: 12.w);
          },
          itemBuilder: (BuildContext context, int index) {
            final message = messages[index];
            return ChatBubble(
              body: Text(message.data),
              sentAt: message.sentAt,
            );
          },
        );
      },
    );
  }
}
