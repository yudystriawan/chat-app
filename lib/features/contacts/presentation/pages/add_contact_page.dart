import 'package:auto_route/auto_route.dart';
import 'package:chat_app/features/contacts/presentation/widgets/contact_list_tile.dart';
import 'package:chat_app/shared/app_bar.dart';
import 'package:coolicons/coolicons.dart';
import 'package:core/core.dart';
import 'package:core/styles/buttons/primary_button.dart';
import 'package:core/styles/input.dart';
import 'package:core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../blocs/contact_loader/contact_loader_bloc.dart';

@RoutePage()
class AddContactPage extends StatelessWidget implements AutoRouteWrapper {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        title: Text('Add Friend'),
      ),
      body: Padding(
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

                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(vertical: 12.w),
                    child: Column(
                      children: [
                        ContactListTile(
                          title: Text(contact.name),
                          subtitle: Text(contact.bio),
                          imageUrl: contact.photoUrl,
                          trailing: PrimaryButton(
                            onPressed: () {},
                            padding: EdgeInsets.symmetric(
                              vertical: 2.w,
                              horizontal: 4.w,
                            ),
                            child: Text(
                              'Add',
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
      ),
    );
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ContactLoaderBloc>(),
      child: this,
    );
  }
}
