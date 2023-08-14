part of 'model.dart';

@freezed
class UserDto with _$UserDto {
  const UserDto._();
  const factory UserDto({
    String? id,
    String? username,
    String? bio,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromFirebase(f_auth.User user) {
    return UserDto(
      bio: '',
      username: '',
      id: user.uid,
      name: user.displayName,
      email: user.email,
      photoUrl: user.photoURL,
      phoneNumber: user.phoneNumber,
    );
  }

  User toDomain() {
    final empty = User.empty();
    return User(
      bio: bio ?? empty.bio,
      username: username ?? empty.username,
      id: id ?? empty.id,
      name: name ?? empty.name,
      email: email ?? empty.email,
      photoUrl: photoUrl ?? empty.photoUrl,
      phoneNumber: phoneNumber ?? empty.phoneNumber,
    );
  }
}
