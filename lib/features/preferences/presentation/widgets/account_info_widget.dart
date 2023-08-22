import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/routes/routes.gr.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/features/auth/presentation/blocs/auth/auth_bloc.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AccountInfoWidget extends StatelessWidget {
  const AccountInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (p, c) => p.user != c.user,
      builder: (context, state) {
        final user = state.user;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pushRoute(
            ProfileRoute(
              initialAccount: Account.fromUser(user),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 50.w,
                width: 50.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: NeutralColor.line,
                  image: user.photoUrl.isEmpty
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            user.photoUrl,
                          ),
                        ),
                ),
                child:
                    user.photoUrl.isEmpty ? const Icon(Coolicons.user) : null,
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name,
                      style: AppTypography.bodyText1,
                    ),
                    Text(
                      user.phoneNumber,
                      style: AppTypography.metadata1
                          .copyWith(color: NeutralColor.disabled),
                    ),
                  ],
                ),
              ),
              const Icon(
                Coolicons.chevron_right,
              ),
            ],
          ),
        );
      },
    );
  }
}
