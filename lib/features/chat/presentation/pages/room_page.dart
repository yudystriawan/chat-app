import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/blocs/member_watcher/member_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/messages_watcher/messages_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_watcher/room_watcher_bloc.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

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
    final userId = context.read<AuthBloc>().state.user.id;

    return MultiBlocListener(
      listeners: [
        BlocListener<MessageFormBloc, MessageFormState>(
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
        ),
        BlocListener<RoomWatcherBloc, RoomWatcherState>(
          listenWhen: (p, c) => p.room != c.room,
          listener: (context, state) {
            final room = state.room;
            if (room.members.isNotEmpty()) {
              context
                  .read<MemberWatcherBloc>()
                  .add(MemberWatcherEvent.watchAllStarted(room.members));
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: MyAppBar(
          title: BlocBuilder<MemberWatcherBloc, MemberWatcherState>(
            builder: (context, state) {
              final members = state.members;

              if (members.isEmpty()) return const Text('Loading...');

              return BlocBuilder<RoomWatcherBloc, RoomWatcherState>(
                builder: (context, state) {
                  final room = state.room;

                  String roomName = room.name;

                  if (room.type.isPrivate) {
                    final recepient =
                        members.filter((member) => member.id != userId).first();
                    roomName = recepient.name;
                  }
                  return Text(roomName);
                },
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
                child: const ChatsContainer(),
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
        BlocProvider(
          create: (context) => getIt<MemberWatcherBloc>(),
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
