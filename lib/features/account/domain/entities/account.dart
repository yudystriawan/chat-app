import 'package:core/features/auth/domain/entities/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account.freezed.dart';

@freezed
class Account with _$Account {
  const Account._();
  const factory Account({
    required String id,
    required String username,
    required String bio,
    required String name,
    required String email,
    required String photoUrl,
    required String phoneNumber,
  }) = _Account;

  factory Account.empty() => const Account(
        id: '',
        username: '',
        bio: '',
        name: '',
        email: '',
        photoUrl: '',
        phoneNumber: '',
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
    );
  }

  bool get isEmpty => this == Account.empty();
  bool get isValid {
    return username.isNotEmpty &&
        name.isNotEmpty &&
        email.isNotEmpty &&
        phoneNumber.isNotEmpty;
  }
}
