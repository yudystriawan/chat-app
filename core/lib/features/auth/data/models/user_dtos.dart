import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as f_auth;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/user.dart';

part 'user_dtos.freezed.dart';
part 'user_dtos.g.dart';

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
    List<String>? contacts,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  factory UserDto.fromFirebaseAuth(f_auth.User user) {
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

  factory UserDto.fromFirestore(DocumentSnapshot doc) {
    return UserDto.fromJson(doc.data() as Map<String, dynamic>)
        .copyWith(id: doc.id);
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
      contacts: contacts?.map((e) => e).toImmutableList() ?? empty.contacts,
    );
  }
}
