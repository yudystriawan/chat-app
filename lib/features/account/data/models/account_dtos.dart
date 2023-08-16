import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
    );
  }
}
