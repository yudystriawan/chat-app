import 'package:chat_app/features/contacts/domain/entities/contact.dart';
import 'package:core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'contact_list_tile.dart';

class ContactListWidget extends StatelessWidget {
  const ContactListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (contacts.isEmpty) return const Text('No Contact');

    return ListView.separated(
      itemCount: contacts.length,
      separatorBuilder: (BuildContext context, int index) {
        return Divider(
          height: 1.w,
          color: NeutralColor.disabled,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        final contact = contacts[index];
        return Padding(
          padding: EdgeInsets.only(top: 16.w, bottom: 12.w),
          child: ContactListTile(
            title: Text(contact.name),
            isOnline: true,
          ),
        );
      },
    );
  }
}

final contacts = [
  const Contact(
    id: '1',
    username: 'username',
    bio: '',
    name: 'Athalia Putri',
    email: 'email',
    photoUrl: 'photoUrl',
    phoneNumber: 'phoneNumber',
  ),
  const Contact(
    id: '1',
    username: 'username',
    bio: '',
    name: 'Erlan Sadewa',
    email: 'email',
    photoUrl: 'photoUrl',
    phoneNumber: 'phoneNumber',
  ),
  const Contact(
    id: '1',
    username: 'username',
    bio: '',
    name: 'Midala Huera',
    email: 'email',
    photoUrl: 'photoUrl',
    phoneNumber: 'phoneNumber',
  ),
  const Contact(
    id: '1',
    username: 'username',
    bio: '',
    name: 'Raki Devon',
    email: 'email',
    photoUrl: 'photoUrl',
    phoneNumber: 'phoneNumber',
  ),
  const Contact(
    id: '1',
    username: 'username',
    bio: '',
    name: 'Salsabila Akira',
    email: 'email',
    photoUrl: 'photoUrl',
    phoneNumber: 'phoneNumber',
  ),
];
