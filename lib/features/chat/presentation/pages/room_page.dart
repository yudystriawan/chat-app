import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_watcher/room_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/chat_bubble.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/chats_container.dart';

@RoutePage()
class RoomPage extends StatelessWidget implements AutoRouteWrapper {
  const RoomPage({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: BlocBuilder<RoomWatcherBloc, RoomWatcherState>(
          builder: (context, state) {
            final room = state.room;
            return Row(
              children: [
                Text(room.name),
              ],
            );
          },
        ),
        trailing: Row(
          children: [
            GhostButton(
              onPressed: () {},
              child: Icon(
                Coolicons.search,
                size: 24.w,
              ),
            ),
            GhostButton(
              onPressed: () {},
              child: Icon(
                Coolicons.hamburger,
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              color: NeutralColor.secondaryBG,
              child: ChatsContainer(
                chats: [
                  ChatBubble(
                    body: const Text(
                        'But don’t worry cause we are all learning here'),
                    sentAt: DateTime.now(),
                  ),
                  ChatBubble(
                    isSender: false,
                    imageUrl: '',
                    body: const Text('Look at how chocho sleep in my arms!'),
                    sentAt: DateTime.now(),
                    recipientName: 'hohoh',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
            decoration: BoxDecoration(
              color: NeutralColor.white,
              border: Border.all(width: 1.w, color: NeutralColor.line),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  GhostButton(
                    onPressed: () {},
                    child: Icon(
                      Coolicons.plus,
                      color: NeutralColor.disabled,
                      size: 24.w,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const Expanded(
                    child: AppTextField(
                      placeholder: 'Type message',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  GhostButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.send,
                      size: 24.w,
                      color: BrandColor.neutral,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<RoomWatcherBloc>()..add(RoomWatcherEvent.watchStarted(roomId)),
      child: this,
    );
  }
}
