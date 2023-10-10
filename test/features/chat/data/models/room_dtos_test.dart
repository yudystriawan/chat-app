import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('RoomDto', () {
    test('fromJson should return a valid RoomDto object', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'members': ['user1', 'user2'],
        'type': 1,
        'roomName': 'Test Room',
        'roomDescription': 'This is a test room',
        'roomImageUrl': 'http://example.com/image.jpg',
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
      };

      final roomDto = RoomDto.fromJson(json);

      expect(roomDto.id, '123');
      expect(roomDto.members, ['user1', 'user2']);
      expect(roomDto.type, 1);
      expect(roomDto.roomName, 'Test Room');
      expect(roomDto.roomDescription, 'This is a test room');
      expect(roomDto.roomImageUrl, 'http://example.com/image.jpg');
      expect(roomDto.createdBy, 'user1');
      expect(roomDto.createdAt, isA<Timestamp>());
    });

    test('toDomain should return a valid Room object', () {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        roomName: 'Test Room',
        roomDescription: 'This is a test room',
        roomImageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: Timestamp.now(),
      );

      final room = roomDto.toDomain();

      expect(room.id, '123');
      expect(room.members, isA<KtList<String>>());
      expect(room.type, isA<RoomType>());
      expect(room.name, 'Test Room');
      expect(room.description, 'This is a test room');
      expect(room.imageUrl, 'http://example.com/image.jpg');
      expect(room.createdBy, 'user1');
      expect(room.createdAt, isA<DateTime>());
    });

    test('fromJson should return a valid RoomDto object', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'members': ['user1', 'user2'],
        'type': 1,
        'roomName': 'Test Room',
        'roomDescription': 'This is a test room',
        'roomImageUrl': 'http://example.com/image.jpg',
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
      };

      final roomDto = RoomDto.fromJson(json);

      expect(roomDto.id, '123');
      expect(roomDto.members, ['user1', 'user2']);
      expect(roomDto.type, 1);
      expect(roomDto.roomName, 'Test Room');
      expect(roomDto.roomDescription, 'This is a test room');
      expect(roomDto.roomImageUrl, 'http://example.com/image.jpg');
      expect(roomDto.createdBy, 'user1');
      expect(roomDto.createdAt, isA<Timestamp>());
    });

    test('toDomain should return a valid Room object', () {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        roomName: 'Test Room',
        roomDescription: 'This is a test room',
        roomImageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: Timestamp.now(),
      );

      final room = roomDto.toDomain();

      expect(room.id, '123');
      expect(room.members, isA<KtList<String>>());
      expect(room.type, isA<RoomType>());
      expect(room.name, 'Test Room');
      expect(room.description, 'This is a test room');
      expect(room.imageUrl, 'http://example.com/image.jpg');
      expect(room.createdBy, 'user1');
      expect(room.createdAt, isA<DateTime>());
    });

    test('toJson should return a valid JSON map', () {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        roomName: 'Test Room',
        roomDescription: 'This is a test room',
        roomImageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: Timestamp.now(),
      );

      final json = roomDto.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], '123');
      expect(json['members'], ['user1', 'user2']);
      expect(json['type'], 1);
      expect(json['roomName'], 'Test Room');
      expect(json['roomDescription'], 'This is a test room');
      expect(json['roomImageUrl'], 'http://example.com/image.jpg');
      expect(json['createdBy'], 'user1');
      expect(json['createdAt'], isA<Timestamp>());
    });
  });
}
