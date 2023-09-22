import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('Message', () {
    test('Message.empty() should create a message with default values', () {
      final message = Message.empty();

      expect(message.id, '');
      expect(message.data, '');
      expect(message.type, MessageType.text);
      expect(message.sentBy, '');
      expect(message.readInfoList, const KtList.empty());
      expect(message.sentAt, isNotNull);
    });

    test('Message should be created with specified values', () {
      final message = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: DateTime.now()),
          ReadInfo(uid: 'user3', readAt: DateTime.now()),
        ),
        sentAt: DateTime.now(),
      );

      expect(message.id, '123');
      expect(message.data, 'Hello, World!');
      expect(message.type, MessageType.text);
      expect(message.sentBy, 'user1');
      expect(message.readInfoList.size, 2);
      expect(message.sentAt, isNotNull);
    });

    test(
        'Message.copyWith() should create a new instance with updated properties',
        () {
      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: DateTime.now()),
          ReadInfo(uid: 'user3', readAt: DateTime.now()),
        ),
        sentAt: DateTime.now(),
      );

      final updatedMessage =
          message1.copyWith(data: 'Updated', sentBy: 'user2');

      expect(updatedMessage.id, message1.id);
      expect(updatedMessage.data, 'Updated');
      expect(updatedMessage.type, message1.type);
      expect(updatedMessage.sentBy, 'user2');
      expect(updatedMessage.readInfoList, message1.readInfoList);
      expect(updatedMessage.sentAt, message1.sentAt);
    });

    test('Message.copyWith() should not modify the original message', () {
      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: DateTime.now()),
          ReadInfo(uid: 'user3', readAt: DateTime.now()),
        ),
        sentAt: DateTime.now(),
      );

      final updatedMessage =
          message1.copyWith(data: 'Updated', sentBy: 'user2');

      expect(updatedMessage.sentBy, 'user2');
      expect(message1.data, 'Hello, World!');
      expect(message1.sentBy, 'user1');
    });

    test('Message should be equal when all properties are the same', () {
      final dateTime = DateTime.now();

      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: dateTime),
          ReadInfo(uid: 'user3', readAt: dateTime),
        ),
        sentAt: dateTime,
      );

      final message2 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: dateTime),
          ReadInfo(uid: 'user3', readAt: dateTime),
        ),
        sentAt: dateTime,
      );

      expect(message1, equals(message2));
    });

    test('Message should not be equal when at least one property is different',
        () {
      final dateTime = DateTime.now();

      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: dateTime),
          ReadInfo(uid: 'user3', readAt: dateTime),
        ),
        sentAt: dateTime,
      );

      final message2 = Message(
        id: '456', // Different id
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        readInfoList: KtList.of(
          ReadInfo(uid: 'user2', readAt: dateTime),
          ReadInfo(uid: 'user3', readAt: dateTime),
        ),
        sentAt: dateTime,
      );

      expect(message1, isNot(equals(message2)));
    });
  });

  group('MessageType', () {
    test('MessageType.fromValue should return the correct enum value', () {
      expect(MessageType.fromValue('text'), MessageType.text);
      expect(MessageType.fromValue('image'), MessageType.image);
      expect(MessageType.fromValue('invalid'),
          MessageType.text); // Handle invalid value
    });
  });

  group('ReadInfo', () {
    test('ReadInfo.empty() should create a ReadInfo object with default values',
        () {
      final readInfo = ReadInfo.empty();

      expect(readInfo.uid, '');
      expect(readInfo.readAt, isNotNull);
    });

    test('ReadInfo should be created with specified values', () {
      final readInfo = ReadInfo(
        uid: 'user1',
        readAt: DateTime.now(),
      );

      expect(readInfo.uid, 'user1');
      expect(readInfo.readAt, isNotNull);
    });

    test(
        'ReadInfo.copyWith() should create a new instance with updated properties',
        () {
      final dateTime = DateTime.now();

      final readInfo1 = ReadInfo(
        uid: 'user1',
        readAt: dateTime,
      );

      final updatedReadInfo =
          readInfo1.copyWith(uid: 'user2', readAt: dateTime);

      expect(updatedReadInfo.uid, 'user2');
      expect(updatedReadInfo.readAt, readInfo1.readAt);
    });

    test('ReadInfo.copyWith() should not modify the original readInfo', () {
      final readInfo1 = ReadInfo(
        uid: 'user1',
        readAt: DateTime.now(),
      );

      final updatedReadInfo =
          readInfo1.copyWith(uid: 'user2', readAt: DateTime.now());

      expect(updatedReadInfo.uid, 'user2');
      expect(readInfo1.uid, 'user1');
    });

    test('ReadInfo should be equal when all properties are the same', () {
      final dateTime = DateTime.now();

      final readInfo1 = ReadInfo(
        uid: 'user1',
        readAt: dateTime,
      );

      final readInfo2 = ReadInfo(
        uid: 'user1',
        readAt: dateTime,
      );

      expect(readInfo1, equals(readInfo2));
    });

    test('ReadInfo should not be equal when at least one property is different',
        () {
      final readInfo1 = ReadInfo(
        uid: 'user1',
        readAt: DateTime.now(),
      );

      final readInfo2 = ReadInfo(
        uid: 'user2', // Different uid
        readAt: DateTime.now(),
      );

      expect(readInfo1, isNot(equals(readInfo2)));
    });
  });
}
