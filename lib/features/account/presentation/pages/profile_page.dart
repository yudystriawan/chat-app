import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/presentation/blocs/profile_form/profile_form_bloc.dart';
import 'package:chat_app/features/account/presentation/widgets/profile_form_widget.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:core/core.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

@RoutePage()
class ProfilePage extends StatelessWidget implements AutoRouteWrapper {
  const ProfilePage({
    Key? key,
    this.initialAccount,
    this.onResult,
  }) : super(key: key);

  final Account? initialAccount;
  final Function(bool isSuccess)? onResult;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Your Profile'),
      ),
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: const ProfileFormWidget()),
      floatingActionButton: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: PrimaryButton(
          onPressed: () {},
          child: const Text('Save'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileFormBloc>(param1: initialAccount),
      child: this,
    );
  }
}
