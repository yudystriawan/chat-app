import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'user.freezed.dart';

mixin BaseUser {
  String get id;
  String get username;
  String get bio;
  String get name;
  String get email;
  String get photoUrl;
  String get phoneNumber;
  KtList<String> get contacts;

  bool get isValid =>
      username.isNotEmpty &&
      name.isNotEmpty &&
      email.isNotEmpty &&
      phoneNumber.isNotEmpty;

  bool get isNotValid => !isValid;
}

@freezed
class User with _$User, BaseUser {
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
}
