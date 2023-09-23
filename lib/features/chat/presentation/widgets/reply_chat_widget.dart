import 'package:chat_app/features/chat/presentation/blocs/member_watcher/member_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_image.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/entity.dart';

class ReplyChatWidget extends StatelessWidget {
  const ReplyChatWidget({
    Key? key,
    required this.message,
    this.onCloseReply,
  }) : super(key: key);

  final Message message;
  final VoidCallback? onCloseReply;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
          buildWhen: (p, c) => p.members != c.members,
          builder: (context, state) {
            final members = state.members;
            // get the sender name
            final recipientName = members
                .firstOrNull((member) => member.id == message.sentBy)
                ?.name;
            return ClipRRect(
              borderRadius: BorderRadius.circular(4.r),
              child: Container(
                width: 317.w,
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: 4.w,
                      color: BrandColor.neutral,
                    ),
                  ),
                  color: NeutralColor.line,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      recipientName ?? '',
                      style: AppTypography.metadata3.copyWith(
                        color: BrandColor.neutral,
                      ),
                    ),
                    4.verticalSpace,
                    if (message.type.isImage) ...[
                      ChatImageNetwork(imageUrl: message.imageUrl),
                      4.verticalSpace,
                    ],
                    if (message.data.isEmpty)
                      const SizedBox()
                    else
                      Text(
                        message.data,
                        style: AppTypography.bodyText2.copyWith(
                          color: NeutralColor.body,
                        ),
                      )
                  ],
                ),
              ),
            );
          },
        ),
        Positioned(
          top: 4.w,
          right: 4.w,
          child: GhostButton(
            onPressed: onCloseReply,
            padding: EdgeInsets.zero,
            child: const Icon(Coolicons.close_small),
          ),
        )
      ],
    );
  }
}
