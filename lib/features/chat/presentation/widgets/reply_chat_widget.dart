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
    this.isSender = false,
    this.onTap,
    this.width,
  }) : super(key: key);

  final Message message;
  final VoidCallback? onCloseReply;
  final bool isSender;
  final Function(String messageId)? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
            buildWhen: (p, c) => p.members != c.members,
            builder: (context, state) {
              final members = state.members;
              // get the sender name
              final recipientName = members
                  .firstOrNull((member) => member.id == message.sentBy)
                  ?.name;
              return GestureDetector(
                onTap: onTap == null ? null : () => onTap!.call(message.id),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.r),
                  child: Container(
                    width: width,
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border(
                        left: BorderSide(
                          width: 4.w,
                          color: isSender
                              ? NeutralColor.white
                              : BrandColor.neutral,
                        ),
                      ),
                      color: isSender ? BrandColor.darkMode : NeutralColor.line,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (message.type.isImage) ...[
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ChatImageNetwork(
                                imageUrl: message.imageUrl,
                                height: 44.w,
                                width: 44.w,
                              ),
                              12.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipientName ?? '',
                                    style: AppTypography.metadata3.copyWith(
                                        color: isSender
                                            ? NeutralColor.white
                                            : BrandColor.neutral),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Coolicons.image,
                                        size: 14.w,
                                        color: isSender
                                            ? NeutralColor.white
                                            : NeutralColor.body,
                                      ),
                                      4.horizontalSpace,
                                      Text(
                                        'Image',
                                        style: AppTypography.metadata3.copyWith(
                                          color: isSender
                                              ? NeutralColor.white
                                              : NeutralColor.body,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          4.verticalSpace,
                        ] else ...[
                          Text(
                            recipientName ?? '',
                            style: AppTypography.metadata3.copyWith(
                                color: isSender
                                    ? NeutralColor.white
                                    : BrandColor.neutral),
                          ),
                          4.verticalSpace,
                          Container(
                            constraints: BoxConstraints(minWidth: 180.w),
                            child: Text(
                              message.data,
                              style: AppTypography.bodyText2.copyWith(
                                color: isSender
                                    ? NeutralColor.white
                                    : NeutralColor.body,
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (onCloseReply != null) ...[
          12.horizontalSpace,
          GhostButton(
            onPressed: onCloseReply,
            padding: EdgeInsets.all(4.w),
            child: const Icon(Coolicons.close_big),
          )
        ]
      ],
    );
  }
}
