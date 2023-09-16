import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

part 'message_dtos.freezed.dart';
part 'message_dtos.g.dart';

@freezed
class MessageDto with _$MessageDto {
  const MessageDto._();
  const factory MessageDto({
    String? id,
    String? data,
    String? type,
    String? sentBy,
    @ServerTimestampConverter() Timestamp? sentAt,
    @JsonKey(name: 'readInfo') List<ReadInfoDto>? readInfoList,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  Message toDomain() {
    final empty = Message.empty();
    return Message(
      id: id ?? empty.id,
      data: data ?? empty.data,
      type: MessageType.fromValue(type),
      sentBy: sentBy ?? empty.sentBy,
      sentAt: sentAt?.toDate() ?? empty.sentAt,
      readInfoList: readInfoList?.map((e) => e.toDomain()).toImmutableList() ??
          empty.readInfoList,
    );
  }
}

@freezed
class ReadInfoDto with _$ReadInfoDto {
  const ReadInfoDto._();
  const factory ReadInfoDto({
    String? uid,
    @ServerTimestampConverter() Timestamp? readAt,
  }) = _ReadInfoDto;

  factory ReadInfoDto.fromJson(Map<String, dynamic> json) =>
      _$ReadInfoDtoFromJson(json);

  ReadInfo toDomain() {
    final empty = ReadInfo.empty();
    return ReadInfo(
      uid: uid ?? empty.uid,
      readAt: readAt?.toDate() ?? empty.readAt,
    );
  }
}
