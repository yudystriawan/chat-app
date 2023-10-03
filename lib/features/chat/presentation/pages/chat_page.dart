import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/app_bar.dart';
import '../blocs/member_watcher/member_watcher_bloc.dart';
import '../blocs/rooms_watcher/rooms_watcher_bloc.dart';
import '../widgets/room_list_widget.dart';

@RoutePage()
class ChatPage extends StatelessWidget implements AutoRouteWrapper {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('Chats'),
        trailing: Row(
          children: [
            GhostButton(
              onPressed: () {},
              child: const Icon(Coolicons.message_plus_alt),
            ),
            SizedBox(width: 8.w),
            GhostButton(
              onPressed: () {},
              child: const Icon(Coolicons.list_check),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 24.w),
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            const SliverToBoxAdapter(
              child: AppTextField(
                placeholder: 'Search',
                prefixIcon: Icon(
                  Coolicons.search,
                ),
              ),
            )
          ],
          body: BlocBuilder<RoomsWatcherBloc, RoomsWatcherState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (state.failureOption.isSome()) {
                return const Center(
                  child: Text('Something went wrong.'),
                );
              }

              return RoomListWidget(rooms: state.rooms);
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<MemberWatcherBloc>(),
      child: this,
    );
  }
}
