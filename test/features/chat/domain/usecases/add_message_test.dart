import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/add_message.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'add_message_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late AddMessage sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = AddMessage(mockRepository);
  });

  const textMessageParams = AddMessageParams(
    roomId: 'roomId',
    message: 'Test message',
    replyMessage: null,
  );

  group('AddMessage Use Case', () {
    test('should add a message to the repository', () async {
      // Arrange
      when(mockRepository.addEditMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        type: anyNamed('type'),
        replyMessage: anyNamed('replyMessage'),
      )).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(textMessageParams);

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.addEditMessage(
        roomId: textMessageParams.roomId,
        message: textMessageParams.message,
        type: textMessageParams.type,
        replyMessage: textMessageParams.replyMessage,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when the repository call fails', () async {
      // Arrange
      const failure = Failure.serverError();
      when(mockRepository.addEditMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        type: anyNamed('type'),
        replyMessage: anyNamed('replyMessage'),
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await sut(textMessageParams);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.addEditMessage(
        roomId: textMessageParams.roomId,
        message: textMessageParams.message,
        type: textMessageParams.type,
        replyMessage: textMessageParams.replyMessage,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate parameters', () async {
      // Arrange
      const invalidParams = AddMessageParams(
        roomId: '', // Invalid roomId
        message: 'Test message',
        replyMessage: null,
      );

      // Act
      final result = await sut(invalidParams);

      // Assert
      expect(
        result,
        const Left(Failure.invalidParameter(message: 'RoomId must not empty')),
      );
      verifyZeroInteractions(mockRepository);
    });
  });
}
