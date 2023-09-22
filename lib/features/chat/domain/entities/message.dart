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
    required KtList<ReadInfo> readInfoList,
    required String imageUrl,
    DateTime? sentAt,
  }) = _Message;

  factory Message.empty() => Message(
        id: '',
        data: '',
        type: MessageType.text,
        sentBy: '',
        imageUrl: '',
        readInfoList: const KtList.empty(),
        sentAt: DateTime.now(),
      );
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
