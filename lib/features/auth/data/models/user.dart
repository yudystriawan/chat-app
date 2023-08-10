part of 'model.dart';

@freezed
class UserDto with _$UserDto {
  const UserDto._();
  const factory UserDto({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromFirebase(f_auth.User user) {
    return UserDto(
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
      id: id ?? empty.id,
      name: name ?? empty.name,
      email: email ?? empty.email,
      photoUrl: photoUrl ?? empty.photoUrl,
      phoneNumber: phoneNumber ?? empty.phoneNumber,
    );
  }
}
