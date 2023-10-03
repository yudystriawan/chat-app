import 'package:auto_route/auto_route.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:core/styles/input.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../shared/app_bar.dart';
import '../../../account/presentation/blocs/account_watcher/account_watcher_bloc.dart';
import '../blocs/contact_actor/contact_actor_bloc.dart';
import '../blocs/contact_loader/contact_loader_bloc.dart';
import '../widgets/contact_list_tile.dart';

@RoutePage()
class AddContactPage extends StatelessWidget implements AutoRouteWrapper {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Add Friend'),
      ),
      body: BlocBuilder<AccountWatcherBloc, AccountWatcherState>(
        builder: (context, state) {
          final contacts = state.account.contacts;
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 16.w, horizontal: 24.w),
            child: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverToBoxAdapter(
                  child: AppTextField(
                    placeholder: 'Find user...',
                    prefixIcon: const Icon(Coolicons.search),
                    onFieldSubmitted: (value) => context
                        .read<ContactLoaderBloc>()
                        .add(ContactLoaderEvent.fetched(value)),
                  ),
                )
              ],
              body: BlocBuilder<ContactLoaderBloc, ContactLoaderState>(
                builder: (context, state) {
                  return state.map(
                    initial: (_) => Center(
                      child: Text(
                        'Find User',
                        style: AppTypography.bodyText1,
                      ),
                    ),
                    loadInProgress: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    loadFailure: (_) => const Center(
                      child: Text('An error occured.'),
                    ),
                    loadSuccess: (value) {
                      final contact = value.contact;
                      final alreadyAdded = contacts.contains(contact.id);

                      return SingleChildScrollView(
                        padding: EdgeInsets.symmetric(vertical: 12.w),
                        child: Column(
                          children: [
                            ContactListTile(
                              title: Text(contact.name),
                              subtitle: Text(contact.bio),
                              imageUrl: contact.photoUrl,
                              trailing: PrimaryButton(
                                onPressed: alreadyAdded
                                    ? null
                                    : () => context
                                        .read<ContactActorBloc>()
                                        .add(ContactActorEvent.contactAdded(
                                            contact.id)),
                                padding: EdgeInsets.symmetric(
                                  vertical: 2.w,
                                  horizontal: 4.w,
                                ),
                                child: Text(
                                  alreadyAdded ? 'Added' : 'Add',
                                  style: AppTypography.metadata1.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<ContactLoaderBloc>(),
        ),
        BlocProvider(
          create: (context) => getIt<ContactActorBloc>(),
        ),
      ],
      child: this,
    );
  }
}
