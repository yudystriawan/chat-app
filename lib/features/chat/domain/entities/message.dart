part of 'entity.dart';

enum MessageType {
  text('text'),
  image('image');

  final String value;
  const MessageType(this.value);

  factory MessageType.fromValue(String? value) {
    return MessageType.values
            .singleWhereOrNull((element) => element.value == value) ??
        MessageType.text;
  }
}

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    required String id,
    required String data,
    required MessageType type,
    required String sentBy,
    DateTime? sentAt,
  }) = _Message;

  factory Message.empty() => const Message(
        id: '',
        data: '',
        type: MessageType.text,
        sentBy: '',
      );
}
