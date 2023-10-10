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
        sentAt: DateTime(2023, 10, 11),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readInfoList: const KtList.empty(),
      );

      // Convert the Message object to a MessageDto.
      final messageDto = MessageDto.fromDomain(message);

      // Validate that the MessageDto was created correctly.
      expect(messageDto.id, '1');
      expect(messageDto.data, 'Hello, World!');
      expect(messageDto.type, 'text');
      expect(messageDto.sentBy, 'user1');
      expect(messageDto.imageUrl, 'https://example.com/image.jpg');
      expect(messageDto.replyMessage, isNull);
      expect(messageDto.readInfoList, isEmpty);
    });

    test('toDomain should create a valid Message from a MessageDto', () {
      // Create a sample MessageDto object.
      final messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: Timestamp.fromDate(DateTime(2023, 10, 11)),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readInfoList: null,
      );

      // Convert the MessageDto object to a Message.
      final message = messageDto.toDomain();

      // Validate that the Message was created correctly.
      expect(message.id, '1');
      expect(message.data, 'Hello, World!');
      expect(message.type, MessageType.text);
      expect(message.sentBy, 'user1');
      expect(message.imageUrl, 'https://example.com/image.jpg');
      expect(message.replyMessage, isNull);
      expect(message.readInfoList, const KtList.empty());
    });

    test('fromJson should create a valid MessageDto from JSON', () {
      // Create a sample JSON Map representing a Message.
      final Map<String, dynamic> json = {
        'id': '1',
        'data': 'Hello, World!',
        'type': 'text',
        'sentBy': 'user1',
        'sentAt': Timestamp.fromDate(DateTime(2023, 10, 11)),
        'imageUrl': 'https://example.com/image.jpg',
        'replyMessage': null,
        'readInfo': [],
      };

      // Convert the JSON Map to a MessageDto.
      final messageDto = MessageDto.fromJson(json);

      // Validate that the MessageDto was created correctly.
      expect(messageDto.id, '1');
      expect(messageDto.data, 'Hello, World!');
      expect(messageDto.type, 'text');
      expect(messageDto.sentBy, 'user1');
      expect(messageDto.imageUrl, 'https://example.com/image.jpg');
      expect(messageDto.replyMessage, isNull);
      expect(messageDto.readInfoList, isEmpty);
    });

    test('toJson should convert a MessageDto to a valid JSON Map', () {
      // Create a sample MessageDto object.
      final messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: Timestamp.fromDate(DateTime(2023, 10, 11)),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readInfoList: [],
      );

      // Convert the MessageDto to a JSON Map.
      final json = messageDto.toJson();

      // Validate that the JSON Map is correct.
      expect(json['id'], '1');
      expect(json['data'], 'Hello, World!');
      expect(json['type'], 'text');
      expect(json['sentBy'], 'user1');
      expect(json['imageUrl'], 'https://example.com/image.jpg');
      expect(json['replyMessage'], isNull);
      expect(json['readInfo'], isEmpty);
    });
  });

  group('ReadInfoDto', () {
    test('fromDomain should create a valid ReadInfoDto from a ReadInfo', () {
      // Create a sample ReadInfo object.
      final readInfo = ReadInfo(
        uid: 'user1',
        readAt: DateTime(2023, 10, 11),
      );

      // Convert the ReadInfo object to a ReadInfoDto.
      final readInfoDto = ReadInfoDto.fromDomain(readInfo);

      // Validate that the ReadInfoDto was created correctly.
      expect(readInfoDto.uid, 'user1');
      expect(readInfoDto.readAt, Timestamp.fromDate(DateTime(2023, 10, 11)));
    });

    test('toDomain should create a valid ReadInfo from a ReadInfoDto', () {
      // Create a sample ReadInfoDto object.
      final readInfoDto = ReadInfoDto(
        uid: 'user1',
        readAt: Timestamp.fromDate(DateTime(2023, 10, 11)),
      );

      // Convert the ReadInfoDto object to a ReadInfo.
      final readInfo = readInfoDto.toDomain();

      // Validate that the ReadInfo was created correctly.
      expect(readInfo.uid, 'user1');
      expect(readInfo.readAt, DateTime(2023, 10, 11));
    });

    test('fromJson should create a valid ReadInfoDto from JSON', () {
      // Create a sample JSON Map representing a ReadInfo.
      final Map<String, dynamic> json = {
        'uid': 'user1',
        'readAt': Timestamp.fromDate(DateTime(2023, 10, 11)),
      };

      // Convert the JSON Map to a ReadInfoDto.
      final readInfoDto = ReadInfoDto.fromJson(json);

      // Validate that the ReadInfoDto was created correctly.
      expect(readInfoDto.uid, 'user1');
      expect(readInfoDto.readAt, Timestamp.fromDate(DateTime(2023, 10, 11)));
    });

    test('toJson should convert a ReadInfoDto to a valid JSON Map', () {
      // Create a sample ReadInfoDto object.
      final readInfoDto = ReadInfoDto(
        uid: 'user1',
        readAt: Timestamp.fromDate(DateTime(2023, 10, 11)),
      );

      // Convert the ReadInfoDto to a JSON Map.
      final json = readInfoDto.toJson();

      // Validate that the JSON Map is correct.
      expect(json['uid'], 'user1');
      expect(json['readAt'], Timestamp.fromDate(DateTime(2023, 10, 11)));
    });
  });
}
