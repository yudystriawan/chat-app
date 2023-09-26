import 'package:chat_app/features/chat/presentation/blocs/member_watcher/member_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/message_form/message_form_bloc.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../../../../shared/hooks/scroll_controller_for_animation.dart';
import '../blocs/messages_watcher/messages_watcher_bloc.dart';
import 'chat_bubble.dart';

class ChatListWidget extends HookWidget {
  final VoidCallback? onLoadMore;

  const ChatListWidget({
    Key? key,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hideFabAnimController = useAnimationController(
      duration: kThemeAnimationDuration,
      initialValue: 0,
    );

    final scrollController = useScrollControllerForAnimation(
      animationController: hideFabAnimController,
      onScrollEnd: onLoadMore,
    );

    final userId = context.read<AuthBloc>().state.user.id;

    return BlocListener<MessageFormBloc, MessageFormState>(
      listenWhen: (p, c) =>
          p.failureOrSuccessOption != c.failureOrSuccessOption,
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () {},
          (either) => either.fold(
            (f) {},
            (_) => _scrollToBottom(scrollController),
          ),
        );
      },
      child: Stack(
        children: [
          BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
            buildWhen: (p, c) => p.members != c.members,
            builder: (context, state) {
              if (state.isLoading || state.members.isEmpty()) {
                return const Center(child: CircularProgressIndicator());
              }

              // get member room exclude myself
              final recipients =
                  state.members.filter((member) => member.id != userId);

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
                    final dateTime =
                        DateTime(sentAt.year, sentAt.month, sentAt.day);
                    return dateTime;
                  });

                  return ListView.builder(
                    controller: scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
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
                            padding: EdgeInsets.symmetric(horizontal: 22.w),
                            reverse: true,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.size,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return SizedBox(height: 12.w);
                            },
                            itemBuilder: (BuildContext context, int index) {
                              final message = items[index];

                              final isSender = userId == message.sentBy;

                              // check status read
                              // when message have read info that not from sender
                              final isRead = message.readInfoList
                                  .filter((readInfo) =>
                                      readInfo.uid != message.sentBy)
                                  .isNotEmpty();

                              // get the sender name
                              final recipientName = recipients
                                  .firstOrNull(
                                      (member) => member.id == message.sentBy)
                                  ?.name;

                              return ChatBubble(
                                body: Text(message.data),
                                sentAt: message.sentAt,
                                isSender: isSender,
                                recipientName: recipientName,
                                isRead: isSender ? isRead : false,
                                imageUrl: message.imageUrl,
                                replyMessage: message.replyMessage,
                                onReplyTapped: (messageId) {
                                  debugPrint('reply tapped: $messageId');
                                },
                                onSwipeRight: () => context
                                    .read<MessageFormBloc>()
                                    .add(MessageFormEvent.replyMessageChanged(
                                        message)),
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
          ),
          Positioned(
            bottom: 4.w,
            right: 4.w,
            child: FadeTransition(
              opacity: hideFabAnimController,
              child: ScaleTransition(
                scale: hideFabAnimController,
                child: GhostButton(
                  padding: const EdgeInsets.all(8),
                  backgroundColor: BrandColor.light,
                  onPressed: () {
                    _scrollToBottom(scrollController);
                  },
                  child: Icon(
                    Coolicons.chevron_down,
                    color: NeutralColor.white,
                    size: 24.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _scrollToBottom(ScrollController scrollController) {
    scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }
}