import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_dtos.freezed.dart';
part 'member_dtos.g.dart';

@freezed
class MemberDto with _$MemberDto {
  const MemberDto._();
  const factory MemberDto({
    String? name,
    @JsonKey(name: 'photoUrl') String? imageUrl,
    String? id,
  }) = _MemberDto;

  factory MemberDto.fromJson(Map<String, dynamic> json) =>
      _$MemberDtoFromJson(json);

  Member toDomain() {
    final empty = Member.empty();
    return Member(
      name: name ?? empty.name,
      imageUrl: imageUrl ?? empty.imageUrl,
      id: id ?? empty.id,
    );
  }
}
