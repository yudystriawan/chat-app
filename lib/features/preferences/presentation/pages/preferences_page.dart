import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/routes.gr.dart';
import '../../../../shared/app_bar.dart';
import '../widgets/account_info_widget.dart';
import '../widgets/preference_item.dart';

@RoutePage()
class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('More'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            const AccountInfoWidget(),
            24.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.user,
              label: 'Account',
              onTapped: () => context.pushRoute(const AccountRoute()),
            ),
            8.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.message_circle,
              label: 'Chats',
              onTapped: () {},
            ),
            24.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.sun,
              label: 'Appereance',
              onTapped: () {},
            ),
            8.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.notification_outline,
              label: 'Notification',
              onTapped: () {},
            ),
            8.verticalSpace,
            PreferenceItemWidget(
              icon: Icons.privacy_tip_outlined,
              label: 'Privacy',
              onTapped: () {},
            ),
            8.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.folder,
              label: 'Data usage',
              onTapped: () {},
            ),
            Divider(height: 16.w),
            PreferenceItemWidget(
              icon: Coolicons.help_circle_outline,
              label: 'Help',
              onTapped: () {},
            ),
            8.verticalSpace,
            PreferenceItemWidget(
              icon: Coolicons.mail,
              label: 'Invite Your Friends',
              onTapped: () {},
            ),
          ],
        ),
      ),
    );
  }
}
