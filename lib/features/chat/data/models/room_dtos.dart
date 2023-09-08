import 'package:chat_app/features/chat/domain/entities/room.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'room_dtos.freezed.dart';
part 'room_dtos.g.dart';

@freezed
class RoomDto with _$RoomDto {
  const RoomDto._();
  const factory RoomDto({
    String? id,
    List<String>? members,
    int? type,
    String? roomName,
    String? roomDescription,
    String? createdBy,
    @ServerTimestampConverter() FieldValue? createdAt,
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
    );
  }
}

class ServerTimestampConverter implements JsonConverter<FieldValue, Object> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object json) => FieldValue.serverTimestamp();

  @override
  Object toJson(FieldValue object) => object;
}
