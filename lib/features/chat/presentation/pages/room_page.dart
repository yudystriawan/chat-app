import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/blocs/messages_watcher/messages_watcher_bloc.dart';
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
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/message_form/message_form_bloc.dart';
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
    return BlocListener<MessageFormBloc, MessageFormState>(
      listenWhen: (p, c) =>
          p.failureOrSuccessOption != c.failureOrSuccessOption,
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (f) => null,
            (_) {
              context
                  .read<MessageFormBloc>()
                  .add(const MessageFormEvent.dataChanged(''));
            },
          ),
        );
      },
      child: Scaffold(
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
                child: BlocBuilder<MessagesWatcherBloc, MessagesWatcherState>(
                  buildWhen: (p, c) => p.messages != c.messages,
                  builder: (context, state) {
                    final messages = state.messages;

                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (messages.isEmpty()) return const SizedBox();

                    return ChatsContainer(
                      chats: messages.iter
                          .map(
                            (message) => ChatBubble(
                              body: Text(message.data),
                              sentAt: message.sentAt,
                            ),
                          )
                          .toList(),
                    );
                  },
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
                      child: MessageTextField(),
                    ),
                    SizedBox(width: 12.w),
                    GhostButton(
                      onPressed: () => context
                          .read<MessageFormBloc>()
                          .add(MessageFormEvent.submitted(roomId)),
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
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<RoomWatcherBloc>()
            ..add(RoomWatcherEvent.watchStarted(roomId)),
        ),
        BlocProvider(
          create: (context) => getIt<MessageFormBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<MessagesWatcherBloc>()
            ..add(MessagesWatcherEvent.watchAllStarted(roomId)),
        ),
      ],
      child: this,
    );
  }
}

class MessageTextField extends HookWidget {
  const MessageTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var controller = useTextEditingController();
    return BlocListener<MessageFormBloc, MessageFormState>(
      listenWhen: (p, c) =>
          p.failureOrSuccessOption != c.failureOrSuccessOption,
      listener: (context, state) {
        state.failureOrSuccessOption.fold(
          () => null,
          (either) => either.fold(
            (f) => null,
            (_) => controller.clear(),
          ),
        );
      },
      child: AppTextField(
        controller: controller,
        placeholder: 'Type message',
        onChange: (value) => context
            .read<MessageFormBloc>()
            .add(MessageFormEvent.dataChanged(value)),
      ),
    );
  }
}
