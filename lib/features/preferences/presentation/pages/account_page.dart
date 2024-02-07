import 'package:auto_route/auto_route.dart';
import 'package:core/styles/buttons/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/app_bar.dart';

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Account'),
      ),
      body: const SizedBox(),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SecondaryButton.error(
            onPressed: () {},
            child: const Text('Delete this account!'),
          ),
        ),
      ),
    );
  }
}
