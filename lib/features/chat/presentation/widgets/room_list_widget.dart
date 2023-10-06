import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:core/utils/extensions/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../../../../routes/routes.gr.dart';
import '../../domain/entities/entity.dart';
import '../blocs/last_message_watcher/last_message_watcher_bloc.dart';
import '../blocs/member_watcher/member_watcher_bloc.dart';
import '../blocs/messages_watcher/messages_watcher_bloc.dart';
import 'room_list_tile.dart';

class RoomListWidget extends StatelessWidget {
  const RoomListWidget({
    Key? key,
    required this.rooms,
  }) : super(key: key);

  final KtList<Room> rooms;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user.id;

    if (rooms.isEmpty()) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'No Chats',
                style: AppTypography.bodyText1,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: rooms.size,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1.w,
          color: NeutralColor.disabled,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        final room = rooms[index];

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => getIt<LastMessageWatcherBloc>()
                ..add(LastMessageWatcherEvent.watchStarted(room.id)),
            ),
            BlocProvider(
              create: (context) => getIt<MemberWatcherBloc>()
                ..add(MemberWatcherEvent.watchAllStarted(room.members)),
            ),
            BlocProvider(
              create: (context) => getIt<MessagesWatcherBloc>()
                ..add(MessagesWatcherEvent.watchUnreadStarted(room.id)),
            )
          ],
          child: Padding(
            padding: EdgeInsets.only(top: 16.w, bottom: 12.w),
            child: BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state.members.isEmpty()) {
                  return const Center(
                    child: Text('No members'),
                  );
                }

                String roomName = room.name;
                String roomImage = room.imageUrl;

                if (room.type.isPrivate) {
                  final recipient = state.members
                      .filter((member) => member.id != userId)
                      .first();
                  roomName = recipient.name;
                  roomImage = recipient.imageUrl;
                }

                return BlocBuilder<MessagesWatcherBloc, MessagesWatcherState>(
                  buildWhen: (p, c) => p.messages != c.messages,
                  builder: (context, state) {
                    final unreadMessages = state.messages;

                    return BlocBuilder<LastMessageWatcherBloc,
                        LastMessageWatcherState>(
                      buildWhen: (p, c) => p.message != c.message,
                      builder: (context, state) {
                        final lastMessage = state.message;

                        Widget subtitle = Text(lastMessage.data);
                        if (lastMessage.type.isImage) {
                          subtitle = Row(
                            children: [
                              Icon(
                                Coolicons.image,
                                size: 12.w,
                                color: NeutralColor.disabled,
                              ),
                              4.horizontalSpace,
                              if (lastMessage.data.isNotEmpty)
                                Text(lastMessage.data)
                              else
                                Text(
                                  'image',
                                  style: AppTypography.metadata1
                                      .copyWith(color: NeutralColor.disabled),
                                )
                            ],
                          );
                        }
                        return RoomListTile(
                          title: Text(roomName),
                          subtitle: subtitle,
                          imageUrl: roomImage,
                          date: lastMessage.sentAt?.toStringDate(),
                          chatCount: unreadMessages.size,
                          onTap: () =>
                              context.pushRoute(RoomRoute(roomId: room.id)),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
