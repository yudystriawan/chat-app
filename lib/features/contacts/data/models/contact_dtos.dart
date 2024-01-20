import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../../account/domain/entities/account.dart';
import '../../domain/entities/contact.dart';

part 'contact_dtos.freezed.dart';
part 'contact_dtos.g.dart';

@freezed
class ContactDto with _$ContactDto {
  const ContactDto._();
  const factory ContactDto({
    String? id,
    String? username,
    String? bio,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    bool? isOnline,
    List<String>? contacts,
  }) = _ContactDto;

  factory ContactDto.fromJson(Map<String, dynamic> json) =>
      _$ContactDtoFromJson(json);

  factory ContactDto.fromDomain(Account account) {
    return ContactDto(
      id: account.id,
      username: account.username,
      bio: account.bio,
      name: account.name,
      email: account.email,
      photoUrl: account.photoUrl,
      phoneNumber: account.phoneNumber,
      contacts: account.contacts.iter.toList(),
    );
  }

  Contact toDomain() {
    final empty = Contact.empty();
    return Contact(
      id: id ?? empty.id,
      username: username ?? empty.username,
      bio: bio ?? empty.bio,
      name: name ?? empty.name,
      email: email ?? empty.email,
      photoUrl: photoUrl ?? empty.photoUrl,
      phoneNumber: phoneNumber ?? empty.phoneNumber,
      isOnline: isOnline ?? empty.isOnline,
      contacts: contacts?.toImmutableList() ?? empty.contacts,
    );
  }
}
