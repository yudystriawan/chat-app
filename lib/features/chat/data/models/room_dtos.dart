import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/entity.dart';

part 'room_dtos.freezed.dart';
part 'room_dtos.g.dart';

@freezed
class RoomDto with _$RoomDto {
  const RoomDto._();
  const factory RoomDto({
    String? id,
    List<String>? members,
    int? type,
    String? name,
    String? description,
    String? imageUrl,
    String? createdBy,
    @ServerTimestampConverter() DateTime? createdAt,
  }) = _RoomDto;

  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);

  Room toDomain() {
    final empty = Room.empty();

    return Room(
      id: id ?? empty.id,
      members: members?.toImmutableList() ?? empty.members,
      createdBy: createdBy ?? empty.createdBy,
      type: RoomType.fromValue(type),
      description: description ?? empty.description,
      imageUrl: imageUrl ?? empty.imageUrl,
      name: name ?? empty.name,
      createdAt: createdAt ?? empty.createdAt,
    );
  }
}
