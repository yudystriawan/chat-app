import 'package:auto_route/auto_route.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          onPressed: () {},
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
          body: const ContactListWidget(),
        ),
      ),
    );
  }
}
