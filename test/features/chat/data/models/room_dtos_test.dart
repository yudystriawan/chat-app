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
        'name': 'Test Room',
        'description': 'This is a test room',
        'imageUrl': 'http://example.com/image.jpg',
        'createdBy': 'user1',
        'createdAt': Timestamp.now(),
      };

      final roomDto = RoomDto.fromJson(json);

      expect(roomDto.id, json['id']);
      expect(roomDto.members, json['members']);
      expect(roomDto.type, json['type']);
      expect(roomDto.name, json['name']);
      expect(roomDto.description, json['description']);
      expect(roomDto.imageUrl, json['imageUrl']);
      expect(roomDto.createdBy, json['createdBy']);
      expect(roomDto.createdAt,
          const ServerTimestampConverter().fromJson(json['createdAt']));
    });

    test('toJson should return a valid JSON map', () {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: DateTime.now(),
      );

      final json = roomDto.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], roomDto.id);
      expect(json['members'], roomDto.members);
      expect(json['type'], roomDto.type);
      expect(json['name'], roomDto.name);
      expect(json['description'], roomDto.description);
      expect(json['imageUrl'], roomDto.imageUrl);
      expect(json['createdBy'], roomDto.createdBy);
      expect(json['createdAt'],
          const ServerTimestampConverter().toJson(roomDto.createdAt));
    });

    test('toDomain should return a valid Room object', () {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: DateTime.now(),
      );

      final room = roomDto.toDomain();

      expect(room.id, roomDto.id);
      expect(room.members, KtList.from(roomDto.members!));
      expect(room.type, RoomType.fromValue(roomDto.type));
      expect(room.name, roomDto.name);
      expect(room.description, roomDto.description);
      expect(room.imageUrl, roomDto.imageUrl);
      expect(room.createdBy, roomDto.createdBy);
      expect(room.createdAt, roomDto.createdAt);
    });
  });
}
