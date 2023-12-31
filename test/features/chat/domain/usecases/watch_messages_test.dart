import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_messages.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_messages_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchMessages sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = WatchMessages(mockRepository);
  });

  const testRoomId = 'testRoomId';
  const testLimit = 10;
  final testMessages = KtList.of(
    const Message(
      data: 'sent',
      id: 'id',
      imageUrl: '',
      readBy: KtMap.empty(),
      sentBy: 'userId1',
      type: MessageType.text,
    ),
    const Message(
      data: 'sent',
      id: 'id2',
      imageUrl: '',
      readBy: KtMap.empty(),
      sentBy: 'userId1',
      type: MessageType.text,
    ),
  );

  group('WatchMessages Use Case', () {
    test('should return a list of Messages from the repository', () async {
      // Arrange
      when(mockRepository.watchMessages(testRoomId, limit: testLimit))
          .thenAnswer((_) => Stream.value(Right(testMessages)));

      // Act
      final result = await sut(
              const WatchMessagesParams(roomId: testRoomId, limit: testLimit))
          .first;

      // Assert
      expect(result, Right(testMessages));
      verify(mockRepository.watchMessages(testRoomId, limit: testLimit))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure from the repository when roomId is empty',
        () async {
      // Arrange
      const failure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');
      when(mockRepository.watchMessages('', limit: testLimit))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result =
          await sut(const WatchMessagesParams(roomId: '', limit: testLimit))
              .first;

      // Assert
      expect(result, const Left(failure));
      verifyZeroInteractions(mockRepository);
    });

    test('should return a Failure from the repository when limit is 0',
        () async {
      // Arrange
      const failure =
          Failure.invalidParameter(message: 'limit must greater than 0');
      when(mockRepository.watchMessages(testRoomId, limit: 0))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result =
          await sut(const WatchMessagesParams(roomId: testRoomId, limit: 0))
              .first;

      // Assert
      expect(result, const Left(failure));
      verifyZeroInteractions(mockRepository);
    });
  });
}
