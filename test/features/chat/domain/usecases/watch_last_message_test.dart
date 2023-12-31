import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_last_message.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_last_message_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchLastMessage sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = WatchLastMessage(mockRepository);
  });

  group('WatchLastMessage Use Case', () {
    test('should return a Message from the repository', () async {
      // Arrange
      final responseMessage = Message(
        id: 'id',
        data: 'data',
        type: MessageType.text,
        sentBy: 'userId',
        readBy: KtMap.from({'user1': true, 'user2': false}),
        imageUrl: '',
        sentAt: DateTime.now(),
      );

      when(mockRepository.watchLastMessage(any))
          .thenAnswer((_) => Stream.value(Right(responseMessage)));

      // Act
      final result = await sut(const WatchLastMessageParams('roomId')).first;

      // Assert
      expect(result, Right(responseMessage));
      verify(mockRepository.watchLastMessage('roomId')).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure from the repository', () async {
      // Arrange
      const failure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');
      when(mockRepository.watchLastMessage('roomId'))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result = await sut(const WatchLastMessageParams('')).first;

      // Assert
      expect(result, const Left(failure));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
