import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/add_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_room_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late AddRoom addRoom;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    addRoom = AddRoom(mockRepository);
  });

  group('AddRoom UseCase', () {
    final membersIds = KtList.from(['user1', 'user2']);
    const roomType = RoomType.private;

    test('should add a room to the repository', () async {
      // Arrange
      final params = AddRoomParams(membersIds: membersIds, type: roomType);
      when(mockRepository.addRoom(
        membersIds: params.membersIds,
        type: params.type.value,
      )).thenAnswer((_) async => const Right('room_id'));

      // Act
      final result = await addRoom(params);

      // Assert
      expect(result, const Right('room_id'));
      verify(
          mockRepository.addRoom(membersIds: membersIds, type: roomType.value));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when room type is invalid', () async {
      // Arrange
      final params = AddRoomParams(
        membersIds: KtList.from(['userId1', 'userId2']),
        type: RoomType.nan,
      );

      // Act
      final result = await addRoom(params);

      // Assert
      expect(
        result,
        const Left(Failure.invalidParameter(message: 'RoomType must be set')),
      );

      // Ensure the repository method is never called.
      verifyNever(mockRepository.addRoom(
        membersIds: membersIds,
        type: roomType.value,
      ));
    });

    test('should return a Failure when members list is empty', () async {
      // Arrange
      const params = AddRoomParams(membersIds: KtList.empty(), type: roomType);

      // Act
      final result = await addRoom(params);

      // Assert
      expect(
        result,
        const Left(
            Failure.invalidParameter(message: 'MembersIds cannot be empty')),
      );

      // Ensure the repository method is never called.
      verifyNever(mockRepository.addRoom(
        membersIds: membersIds,
        type: roomType.value,
      ));
    });

    test('should set roomType to Group when members size is more than 2',
        () async {
      // Arrange
      final membersIds = KtList.from(['user1', 'user2', 'user3']);
      final params =
          AddRoomParams(membersIds: membersIds, type: RoomType.group);
      when(mockRepository.addRoom(
        membersIds: params.membersIds,
        type: params.type.value,
      )).thenAnswer((_) async => const Right('roomId'));

      // Act
      final result = await addRoom(params);

      // Assert
      expect(result, const Right('roomId'));
      verify(mockRepository.addRoom(
        membersIds: params.membersIds,
        type: params.type.value,
      ));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
