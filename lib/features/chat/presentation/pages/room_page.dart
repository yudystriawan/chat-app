import 'package:auto_route/auto_route.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:flutter/material.dart';

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
        title: Row(
          children: [
            Text(roomId),
          ],
        ),
      ),
      body: Container(),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }
}
