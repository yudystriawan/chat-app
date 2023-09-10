import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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
      sentAt: sentAt?.toDate(),
    );
  }
}
