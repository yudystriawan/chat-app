import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    required String id,
    required String username,
    required String bio,
    required String name,
    required String email,
    required String photoUrl,
    required String phoneNumber,
    required KtList<String> contacts,
  }) = _User;

  factory User.empty() => const User(
        id: '',
        username: '',
        bio: '',
        name: '',
        email: '',
        photoUrl: '',
        phoneNumber: '',
        contacts: KtList.empty(),
      );

  bool get isEmpty => this == User.empty();

  bool get isValid =>
      username.isNotEmpty &&
      name.isNotEmpty &&
      email.isNotEmpty &&
      phoneNumber.isNotEmpty;

  bool get isNotValid => !isValid;
}
