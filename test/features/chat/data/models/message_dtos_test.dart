import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('MessageDto', () {
    test('fromDomain should create a valid MessageDto from a Message', () {
      // Create a sample Message object.
      final message = Message(
        id: '1',
        data: 'Hello, World!',
        type: MessageType.text,
        sentBy: 'user1',
        sentAt: DateTime.now(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: KtMap.from({'user1': true, 'user2': false}),
      );

      // Convert the Message object to a MessageDto.
      final messageDto = MessageDto.fromDomain(message);

      // Validate that the MessageDto was created correctly.
      expect(messageDto.id, message.id);
      expect(messageDto.data, message.data);
      expect(messageDto.type, message.type.value);
      expect(messageDto.sentBy, message.sentBy);
      expect(messageDto.sentAt, message.sentAt);
      expect(messageDto.imageUrl, message.imageUrl);
      expect(messageDto.replyMessage, message.replyMessage);
      expect(messageDto.readBy, message.readBy.asMap());
    });

    test('toDomain should create a valid Message from a MessageDto', () {
      // Create a sample MessageDto object.
      final messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: DateTime.now(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': true, 'user2': false},
      );

      // Convert the MessageDto object to a Message.
      final message = messageDto.toDomain();

      // Validate that the Message was created correctly.
      expect(message.id, messageDto.id);
      expect(message.data, messageDto.data);
      expect(message.type, MessageType.fromValue(messageDto.type));
      expect(message.sentAt, messageDto.sentAt);
      expect(message.sentBy, messageDto.sentBy);
      expect(message.imageUrl, messageDto.imageUrl);
      expect(message.replyMessage, isNull);
      expect(message.readBy, KtMap.from(messageDto.readBy));
    });

    test('fromJson should create a valid MessageDto from JSON', () {
      // Create a sample JSON Map representing a Message.
      final Map<String, dynamic> json = {
        'id': '1',
        'data': 'Hello, World!',
        'type': 'text',
        'sentBy': 'user1',
        'sentAt': Timestamp.fromDate(DateTime.now()),
        'imageUrl': 'https://example.com/image.jpg',
        'replyMessage': null,
        'readBy': {'user1': true, 'user2': false},
      };

      // Convert the JSON Map to a MessageDto.
      final messageDto = MessageDto.fromJson(json);

      // Validate that the MessageDto was created correctly.
      expect(messageDto.id, json['id']);
      expect(messageDto.data, json['data']);
      expect(messageDto.type, json['type']);
      expect(messageDto.sentBy, json['sentBy']);
      expect(messageDto.sentAt,
          const ServerTimestampConverter().fromJson(json['sentAt']));
      expect(messageDto.imageUrl, json['imageUrl']);
      expect(messageDto.replyMessage, isNull);
      expect(messageDto.readBy, json['readBy']);
    });

    test('toJson should convert a MessageDto to a valid JSON Map', () {
      // Create a sample MessageDto object.
      final messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: DateTime.now(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': true, 'user2': false},
      );

      // Convert the MessageDto to a JSON Map.
      final json = messageDto.toJson();

      // Validate that the JSON Map is correct.
      expect(json['id'], messageDto.id);
      expect(json['data'], messageDto.data);
      expect(json['type'], messageDto.type);
      expect(json['sentBy'], messageDto.sentBy);
      expect(json['sentAt'],
          const ServerTimestampConverter().toJson(messageDto.sentAt));
      expect(json['imageUrl'], messageDto.imageUrl);
      expect(json['replyMessage'], isNull);
      expect(json['readBy'], messageDto.readBy);
    });
  });
}
