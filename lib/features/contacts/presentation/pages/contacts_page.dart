import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/routes.gr.dart';
import '../../../../shared/app_bar.dart';
import '../blocs/contact_watcher/contact_watcher_bloc.dart';
import '../widgets/contact_list_widget.dart';

@RoutePage()
class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: const Text('Contact'),
        trailing: GhostButton(
          onPressed: () => context.pushRoute(const AddContactRoute()),
          child: Icon(
            Coolicons.plus,
            size: 24.w,
          ),
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
          body: BlocBuilder<ContactWatcherBloc, ContactWatcherState>(
            builder: (context, state) {
              return state.map(
                initial: (_) => const SizedBox(),
                loadInProgress: (_) => const SizedBox(),
                loadFailure: (_) => const SizedBox(),
                loadSuccess: (value) =>
                    ContactListWidget(contacts: value.contacts),
              );
            },
          ),
        ),
      ),
    );
  }
}
