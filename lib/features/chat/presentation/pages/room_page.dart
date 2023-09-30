import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/blocs/member_watcher/member_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/messages_watcher/messages_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_actor/room_actor_bloc.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_watcher/room_watcher_bloc.dart';
import 'package:chat_app/features/chat/presentation/widgets/reply_chat_widget.dart';
import 'package:chat_app/features/chat/presentation/widgets/show_attachments_bottom_sheet.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/input.dart';
import 'package:core/utils/images/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../blocs/message_form/message_form_bloc.dart';
import '../widgets/chat_list_widget.dart';

@RoutePage()
class RoomPage extends StatefulWidget implements AutoRouteWrapper {
  const RoomPage({
    Key? key,
    required this.roomId,
  }) : super(key: key);

  final String roomId;

  @override
  State<RoomPage> createState() => _RoomPageState();

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

class _RoomPageState extends State<RoomPage> {
  late RoomActorBloc _roomActorBloc;

  @override
  void initState() {
    super.initState();
    _roomActorBloc = context.read<RoomActorBloc>();

    _roomActorBloc.add(RoomActorEvent.roomEntered(widget.roomId));
  }

  @override
  void dispose() {
    _roomActorBloc.add(RoomActorEvent.roomExited(widget.roomId));
    super.dispose();
  }

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
          listenWhen: (p, c) => p.room.id != c.room.id,
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
                child: ChatListWidget(
                  onLoadMore: () => context
                      .read<MessagesWatcherBloc>()
                      .add(MessagesWatcherEvent.watchAllStarted(widget.roomId)),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 12.w),
              decoration: BoxDecoration(
                color: NeutralColor.white,
                border: Border.all(width: 1.w, color: NeutralColor.line),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocBuilder<MessageFormBloc, MessageFormState>(
                    buildWhen: (p, c) => p.replyMessage != c.replyMessage,
                    builder: (context, state) {
                      if (state.replyMessage == null) return const SizedBox();
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReplyChatWidget(
                            width: double.infinity,
                            message: state.replyMessage!,
                            onCloseReply: () => context
                                .read<MessageFormBloc>()
                                .add(const MessageFormEvent.replyMessageChanged(
                                  null,
                                )),
                          ),
                          10.verticalSpace,
                        ],
                      );
                    },
                  ),
                  BlocBuilder<MessageFormBloc, MessageFormState>(
                    buildWhen: (p, c) => p.imageFile != c.imageFile,
                    builder: (context, state) {
                      if (state.imageFile == null) return const SizedBox();

                      return Column(
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12.r),
                                child: Image.file(
                                  state.imageFile!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 180.w,
                                ),
                              ),
                              Positioned(
                                top: 8.w,
                                right: 8.w,
                                child: GhostButton(
                                  onPressed: () => context
                                      .read<MessageFormBloc>()
                                      .add(const MessageFormEvent
                                          .imageFileChanged(null)),
                                  padding: EdgeInsets.all(2.w),
                                  backgroundColor:
                                      NeutralColor.offWhite.withOpacity(0.5),
                                  child: const Icon(Coolicons.close_big),
                                ),
                              ),
                            ],
                          ),
                          10.verticalSpace,
                        ],
                      );
                    },
                  ),
                  SafeArea(
                    top: false,
                    child: Row(
                      children: [
                        GhostButton(
                          onPressed: () async {
                            await _sendImage(context);
                          },
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
                        BlocBuilder<MessageFormBloc, MessageFormState>(
                          buildWhen: (p, c) => p.isSubmitting != c.isSubmitting,
                          builder: (context, state) {
                            if (state.isSubmitting) {
                              return const CircularProgressIndicator();
                            }

                            return GhostButton(
                              onPressed: () => context
                                  .read<MessageFormBloc>()
                                  .add(MessageFormEvent.submitted(
                                      widget.roomId)),
                              child: Icon(
                                Icons.send,
                                size: 24.w,
                                color: BrandColor.neutral,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _sendImage(BuildContext context) async {
    var attachment = await showAttachmentsBottomSheet(context);

    if (attachment == null) return;

    if (attachment.isCamera || attachment.isGallery) {
      final pickedImage =
          await ImageUtils.pickImage(attachment.toImageOrigin());

      if (pickedImage == null) return;

      final compressedImage = await ImageUtils.compressImage(
        pickedImage.path,
      );

      if (compressedImage == null) return;

      // ignore: use_build_context_synchronously
      context
          .read<MessageFormBloc>()
          .add(MessageFormEvent.imageFileChanged(compressedImage));
    }

    return;
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
