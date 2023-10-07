import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_chat_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_chat_room_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchChatRoom watchChatRoom;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    watchChatRoom = WatchChatRoom(mockRepository);
  });

  group('WatchChatRoom Use Case', () {
    test('should emit Failure if roomId is empty', () {
      // Arrange
      const params = WatchChatRoomParams(roomId: '');

      // Act
      final result = watchChatRoom(params);

      // Assert
      expect(
        result,
        emitsInOrder([
          const Left(
              Failure.invalidParameter(message: 'RoomId cannot be empty.'))
        ]),
      );
    });

    test('should call repository.watchChatRoom with correct parameters', () {
      // Arrange
      const roomId = 'roomId';
      const params = WatchChatRoomParams(roomId: roomId);
      when(mockRepository.watchChatRoom(roomId)).thenAnswer(
        (_) => Stream.value(
          Right(Room(
            id: 'roomId',
            createdBy: 'userId1',
            description: '',
            imageUrl: '',
            members: KtList.from(['userId1, userId2']),
            name: '',
            type: RoomType.private,
            createdAt: DateTime.now(),
          )),
        ),
      );

      // Act
      final result = watchChatRoom(params);

      // Assert
      expect(result, emits(isA<Right<Failure, Room>>()));
    });
  });
}
