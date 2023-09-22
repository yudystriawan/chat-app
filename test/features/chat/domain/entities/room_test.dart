import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('Room', () {
    test('Room.empty() should create a room with default values', () {
      final room = Room.empty();

      expect(room.id, '');
      expect(room.members, const KtList.empty());
      expect(room.createdBy, '');
      expect(room.type, RoomType.nan);
      expect(room.description, '');
      expect(room.imageUrl, '');
      expect(room.name, '');
      expect(room.createdAt, isNull);
    });

    test('Room should be created with specified values', () {
      final room = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: DateTime.now(),
      );

      expect(room.id, '123');
      expect(room.members, KtList.of('user1', 'user2'));
      expect(room.createdBy, 'user1');
      expect(room.type, RoomType.private);
      expect(room.description, 'Sample room');
      expect(room.imageUrl, 'sample.jpg');
      expect(room.name, 'Sample Room');
      expect(room.createdAt, isNotNull);
    });

    test('Room.copyWith() should create a new instance with updated properties',
        () {
      final room1 = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: DateTime.now(),
      );

      final updatedRoom =
          room1.copyWith(description: 'Updated', createdBy: 'user2');

      expect(updatedRoom.id, room1.id);
      expect(updatedRoom.members, room1.members);
      expect(updatedRoom.type, room1.type);
      expect(updatedRoom.description, 'Updated');
      expect(updatedRoom.imageUrl, room1.imageUrl);
      expect(updatedRoom.name, room1.name);
      expect(updatedRoom.createdAt, room1.createdAt);
    });

    test('Room.copyWith() should not modify the original room', () {
      final room1 = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: DateTime.now(),
      );

      final updatedRoom =
          room1.copyWith(description: 'Updated', createdBy: 'user2');

      expect(updatedRoom.createdBy, 'user2');
      expect(room1.description, 'Sample room');
      expect(room1.createdBy, 'user1');
    });

    test('Room should be equal when all properties are the same', () {
      final dateTime = DateTime.now();

      final room1 = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: dateTime,
      );

      final room2 = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: dateTime,
      );

      expect(room1, equals(room2));
    });

    test('Room should not be equal when at least one property is different',
        () {
      final room1 = Room(
        id: '123',
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: DateTime.now(),
      );

      final room2 = Room(
        id: '456', // Different id
        members: KtList.of('user1', 'user2'),
        createdBy: 'user1',
        type: RoomType.private,
        description: 'Sample room',
        imageUrl: 'sample.jpg',
        name: 'Sample Room',
        createdAt: DateTime.now(),
      );

      expect(room1, isNot(equals(room2)));
    });

    group('RoomType', () {
      test('RoomType.fromValue should return the correct enum value', () {
        expect(RoomType.fromValue(0), RoomType.nan);
        expect(RoomType.fromValue(1), RoomType.private);
        expect(RoomType.fromValue(2), RoomType.group);
        expect(RoomType.fromValue(null), RoomType.nan); // Handle null value
      });

      test('RoomType.fromValue should handle an invalid value', () {
        expect(RoomType.fromValue(3), RoomType.nan);
        expect(RoomType.fromValue(-1), RoomType.nan);
      });

      test('Room type getters should work as expected', () {
        final privateRoom = Room(
          id: '123',
          members: KtList.of('user1', 'user2'),
          createdBy: 'user1',
          type: RoomType.private,
          description: 'Sample room',
          imageUrl: 'sample.jpg',
          name: 'Sample Room',
          createdAt: DateTime.now(),
        );

        final groupRoom = Room(
          id: '456',
          members: KtList.of('user3', 'user4'),
          createdBy: 'user3',
          type: RoomType.group,
          description: 'Another room',
          imageUrl: 'another.jpg',
          name: 'Another Room',
          createdAt: DateTime.now(),
        );

        expect(privateRoom.type.isPrivate, true);
        expect(privateRoom.type.isGroup, false);

        expect(groupRoom.type.isPrivate, false);
        expect(groupRoom.type.isGroup, true);
      });
    });
  });
}
