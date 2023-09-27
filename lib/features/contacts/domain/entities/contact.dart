import 'package:core/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'contact.freezed.dart';

@freezed
class Contact with _$Contact, BaseUser {
  const Contact._();
  const factory Contact({
    required String id,
    required String username,
    required String bio,
    required String name,
    required String email,
    required String photoUrl,
    required String phoneNumber,
    required bool isOnline,
    required KtList<String> contacts,
  }) = _Contact;

  factory Contact.empty() => const Contact(
        id: '',
        username: '',
        bio: '',
        name: '',
        email: '',
        photoUrl: '',
        phoneNumber: '',
        contacts: KtList.empty(),
        isOnline: false,
      );
}
