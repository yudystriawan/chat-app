import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/chat/presentation/widgets/room_list_tile.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/room.dart';

class RoomListWidget extends StatelessWidget {
  const RoomListWidget({
    Key? key,
    required this.rooms,
  }) : super(key: key);

  final KtList<Room> rooms;

  @override
  Widget build(BuildContext context) {
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

        String roomName = _getRoomName(room);

        return Padding(
          padding: EdgeInsets.only(top: 16.w, bottom: 12.w),
          child: RoomListTile(
            title: Text(roomName),
            onTap: () => context.pushRoute(RoomRoute(roomId: room.id)),
          ),
        );
      },
    );
  }

  /// if type is personal
  /// return the recipient
  String _getRoomName(Room room) {
    if (room.type.isPrivate) {
      final createdBy = room.createdBy;
      final recipient =
          room.members.filterNot((id) => id == createdBy).joinToString();
      return recipient;
    }

    //TODO: get room name when it group;
    return '';
  }
}
