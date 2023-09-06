import 'package:freezed_annotation/freezed_annotation.dart';

part 'room_dtos.freezed.dart';
part 'room_dtos.g.dart';

@freezed
class RoomDto with _$RoomDto {
  const RoomDto._();
  const factory RoomDto({
    String? id,
    List<String>? userIds,
    String? createdAt,
    String? createdBy,
    int? type,
  }) = _RoomDto;

  factory RoomDto.fromJson(Map<String, dynamic> json) =>
      _$RoomDtoFromJson(json);
}
