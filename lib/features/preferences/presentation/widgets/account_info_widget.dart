import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/styles/colors.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../routes/routes.gr.dart';
import '../../../account/presentation/blocs/account_watcher/account_watcher_bloc.dart';

class AccountInfoWidget extends StatelessWidget {
  const AccountInfoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountWatcherBloc, AccountWatcherState>(
      buildWhen: (p, c) => p.account != c.account,
      builder: (context, state) {
        final account = state.account;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.pushRoute(
            ProfileRoute(initialAccount: account),
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
                  image: account.photoUrl.isEmpty
                      ? null
                      : DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            account.photoUrl,
                          ),
                        ),
                ),
                child: account.photoUrl.isEmpty
                    ? const Icon(Coolicons.user)
                    : null,
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.name,
                      style: AppTypography.bodyText1,
                    ),
                    Text(
                      account.phoneNumber,
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
