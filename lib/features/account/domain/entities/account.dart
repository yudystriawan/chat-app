import 'package:core/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account, BaseUser {
  const Account._();
  const factory Account({
    required String id,
    required String username,
    required String bio,
    required String name,
    required String email,
    required String photoUrl,
    required String phoneNumber,
    required KtList<String> contacts,
    DateTime? expiredAt,
  }) = _Account;

  factory Account.empty() => const Account(
        id: '',
        username: '',
        bio: '',
        name: '',
        email: '',
        photoUrl: '',
        phoneNumber: '',
        contacts: KtList.empty(),
      );

  factory Account.fromUser(User user) {
    return Account(
      id: user.id,
      username: user.username,
      bio: user.bio,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      phoneNumber: user.phoneNumber,
      contacts: user.contacts,
    );
  }

  bool get isEmpty => this == Account.empty();
}
