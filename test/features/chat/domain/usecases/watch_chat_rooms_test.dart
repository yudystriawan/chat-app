import 'dart:async';

import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_chat_rooms.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_chat_rooms_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchChatRooms sut;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sut = WatchChatRooms(mockChatRepository);
  });

  group('WatchChatRooms use case', () {
    test('should return a list of rooms from the repository', () async {
      final createdAt = DateTime.now();
      // Arrange
      final rooms = KtList.from([
        Room(
          id: 'roomId',
          createdBy: 'userId1',
          description: '',
          imageUrl: '',
          members: KtList.from(['userId1, userId2']),
          name: '',
          type: RoomType.private,
          createdAt: createdAt,
        ),
        Room(
          id: 'roomId2',
          createdBy: 'userId2',
          description: '',
          imageUrl: '',
          members: KtList.from(['userId3, userId2']),
          name: '',
          type: RoomType.private,
          createdAt: createdAt,
        )
      ]);

      when(mockChatRepository.watchChatRooms())
          .thenAnswer((_) => Stream.value(Right(rooms)));

      // Act
      final result = sut(const NoParams());

      // Assert
      expect(result, emitsInOrder([Right(rooms)]));
      verify(mockChatRepository.watchChatRooms()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return a failure from the repository', () async {
      // Arrange
      const failure = Failure.serverError();
      when(mockChatRepository.watchChatRooms())
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result = sut(const NoParams());

      // Assert
      expect(result, emits(const Left(failure)));
      verify(mockChatRepository.watchChatRooms()).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });
  });
}
