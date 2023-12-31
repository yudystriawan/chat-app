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
      expect(message.sentAt, isNull);
      expect(message.readBy, const KtMap.empty());
    });

    test('Message should be created with specified values', () {
      final sentAt = DateTime.now();
      final message = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
        sentAt: sentAt,
      );

      expect(message.id, '123');
      expect(message.data, 'Hello, World!');
      expect(message.type, MessageType.text);
      expect(message.sentBy, 'user1');
      expect(message.readBy, KtMap.from({'user1': true, 'user2': false}));
      expect(message.sentAt, sentAt);
    });

    test(
        'Message.copyWith() should create a new instance with updated properties',
        () {
      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
        sentAt: DateTime.now(),
      );

      final updatedMessage =
          message1.copyWith(data: 'Updated', sentBy: 'user2');

      expect(updatedMessage.id, message1.id);
      expect(updatedMessage.data, 'Updated');
      expect(updatedMessage.type, message1.type);
      expect(updatedMessage.sentBy, 'user2');
      expect(updatedMessage.readBy, message1.readBy);
      expect(updatedMessage.sentAt, message1.sentAt);
    });

    test('Message.copyWith() should not modify the original message', () {
      final message1 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
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
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
        sentAt: dateTime,
      );

      final message2 = Message(
        id: '123',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
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
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),
        sentAt: dateTime,
      );

      final message2 = Message(
        id: '456', // Different id
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        imageUrl: 'image.jpg',
        readBy: KtMap.from({'user1': true, 'user2': false}),

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
}
