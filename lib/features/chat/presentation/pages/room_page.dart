import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/blocs/room_watcher/room_watcher_bloc.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      ),
      body: Container(),
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
