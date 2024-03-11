import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import 'package:chat_app/shared/show_info_dialog.dart';
import 'package:chat_app/shared/types/date_extensions.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/buttons/ghost_button.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            BlocBuilder<AccountWatcherBloc, AccountWatcherState>(
              builder: (context, state) {
                if (state.account.expiredAt == null) {
                  return 12.verticalSpaceFromWidth;
                }

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.w),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0).w,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Warning',
                                style: AppTypography.bodyText1.bold.copyWith(
                                  color: AccentColor.danger,
                                ),
                              ),
                              GhostButton(
                                onPressed: () => showInfoDialog(
                                  context,
                                  content:
                                      'Please note that this account is temporary and will be deleted at the designated time. Any data you have entered or modified may be lost after deletion.',
                                ),
                                child: Icon(
                                  Coolicons.info_circle_outline,
                                  size: 16.w,
                                ),
                              ),
                            ],
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'Your account will be expired at ',
                              children: [
                                TextSpan(
                                  text: state.account.expiredAt
                                      ?.toFormattedString(),
                                  style: AppTypography.metadata1.bold,
                                )
                              ],
                              style: AppTypography.metadata1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
            Divider(
              height: 16.w,
            ),
            16.verticalSpaceFromWidth,
            Align(
              alignment: Alignment.centerRight,
              child: GhostButton(
                onPressed: () =>
                    context.read<AuthBloc>().add(const AuthEvent.signOut()),
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: const Text('Sign Out'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
