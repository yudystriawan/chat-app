import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/domain/entities/room.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_actor/room_actor_bloc.dart';
import 'package:chat_app/features/contacts/domain/entities/contact.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kt_dart/collection.dart';

@RoutePage()
class RoomPage extends StatelessWidget implements AutoRouteWrapper {
  const RoomPage({
    Key? key,
    required this.contact,
  }) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoomActorBloc, RoomActorState>(
      listener: (context, state) {
        state.map(
          initial: (_) {},
          actionInProgress: (_) {},
          actionFailure: (_) {
            debugPrint('an error occured');
          },
          removeRoomSuccess: (_) {},
          addRoomSuccess: (_) {},
        );
      },
      child: Scaffold(
        appBar: MyAppBar(
          title: Row(
            children: [
              Text(contact.name),
            ],
          ),
        ),
        body: BlocBuilder<RoomActorBloc, RoomActorState>(
          builder: (context, state) {
            return Container();
          },
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<RoomActorBloc>()
        ..add(RoomActorEvent.roomAdded(
          userIds: KtList.from([contact.id]),
          type: RoomType.private,
        )),
      child: this,
    );
  }
}
