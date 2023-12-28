import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/entities/entity.dart';

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
    String? imageUrl,
    MessageDto? replyMessage,
    @ServerTimestampConverter() Timestamp? sentAt,
    @JsonKey(includeIfNull: true) Map<String, bool>? readBy,
  }) = _MessageDto;

  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);

  factory MessageDto.fromDomain(Message domain) {
    return MessageDto(
      id: domain.id,
      data: domain.data,
      type: domain.type.value,
      sentBy: domain.sentBy,
      sentAt: domain.sentAt != null ? Timestamp.fromDate(domain.sentAt!) : null,
      imageUrl: domain.imageUrl,
      replyMessage: domain.replyMessage != null
          ? MessageDto.fromDomain(domain.replyMessage!)
          : null,
      readBy: domain.readBy.asMap(),
    );
  }

  Message toDomain() {
    final empty = Message.empty();
    return Message(
      id: id ?? empty.id,
      data: data ?? empty.data,
      type: MessageType.fromValue(type),
      sentBy: sentBy ?? empty.sentBy,
      sentAt: sentAt?.toDate() ?? empty.sentAt,
      readBy: readBy != null ? KtMap.from(readBy!) : const KtMap.empty(),
      imageUrl: imageUrl ?? empty.imageUrl,
      replyMessage: replyMessage?.toDomain(),
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

  factory ReadInfoDto.fromDomain(ReadInfo domain) {
    return ReadInfoDto(
      uid: domain.uid,
      readAt: Timestamp.fromDate(domain.readAt),
    );
  }

  ReadInfo toDomain() {
    final empty = ReadInfo.empty();
    return ReadInfo(
      uid: uid ?? empty.uid,
      readAt: readAt?.toDate() ?? empty.readAt,
    );
  }
}
