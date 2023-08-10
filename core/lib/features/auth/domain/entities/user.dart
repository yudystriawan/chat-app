import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const User._();
  const factory User({
    required String id,
    required String name,
    required String email,
    required String photoUrl,
    required String phoneNumber,
  }) = _User;

  factory User.empty() => const User(
        id: '',
        name: '',
        email: '',
        photoUrl: '',
        phoneNumber: '',
      );
}
