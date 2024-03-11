import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/account.dart';

part 'account_dtos.freezed.dart';
part 'account_dtos.g.dart';

@freezed
class AccountDto with _$AccountDto {
  const AccountDto._();
  const factory AccountDto({
    String? id,
    String? username,
    String? bio,
    String? name,
    String? email,
    String? photoUrl,
    String? phoneNumber,
    List<String>? contacts,
    @ServerTimestampConverter() ServerTimestamp? expiredAt,
  }) = _AccountDto;

  factory AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  factory AccountDto.fromDomain(Account account) {
    return AccountDto(
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

  Account toDomain() {
    final empty = Account.empty();
    return Account(
      id: id ?? empty.id,
      username: username ?? empty.username,
      bio: bio ?? empty.bio,
      name: name ?? empty.name,
      email: email ?? empty.email,
      photoUrl: photoUrl ?? empty.photoUrl,
      phoneNumber: phoneNumber ?? empty.phoneNumber,
      contacts: contacts?.toImmutableList() ?? empty.contacts,
      expiredAt: expiredAt?.toDate(),
    );
  }
}
