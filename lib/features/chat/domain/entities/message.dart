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

  bool get isText => this == MessageType.text;
  bool get isImage => this == MessageType.image;
}

@freezed
class Message with _$Message {
  const Message._();

  const factory Message({
    required String id,
    required String data,
    required MessageType type,
    required String sentBy,
    required KtMap<String, bool> readBy,
    required String imageUrl,
    DateTime? sentAt,
    Message? replyMessage,
  }) = _Message;

  factory Message.empty() => const Message(
        id: '',
        data: '',
        type: MessageType.text,
        sentBy: '',
        imageUrl: '',
        readBy: KtMap.empty(),
      );

  bool get hasReplyMessage => replyMessage != null;
  bool get isReplyFromMyself =>
      hasReplyMessage && sentBy == replyMessage!.sentBy;
}

@freezed
class ReadInfo with _$ReadInfo {
  const ReadInfo._();
  const factory ReadInfo({
    required String uid,
    required DateTime readAt,
  }) = _ReadInfo;

  factory ReadInfo.empty() => ReadInfo(uid: '', readAt: DateTime.now());
}
