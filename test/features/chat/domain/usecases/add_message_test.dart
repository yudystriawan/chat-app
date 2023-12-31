import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/add_message.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
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

  const params = AddMessageParams(
    roomId: 'roomId',
    message: 'Test message',
    type: MessageType.text,
    replyMessage: null,
  );

  final responseMessage = Message(
    id: 'messageId',
    data: 'Test message',
    imageUrl: '',
    readBy: KtMap.from({'user1': true, 'user2': false}),
    sentBy: 'userId',
    type: MessageType.text,
    sentAt: DateTime.now(),
  );

  group('AddMessage Use Case', () {
    test('should add a message to the repository', () async {
      // Arrange
      when(mockRepository.addMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        type: anyNamed('type'),
        replyMessage: anyNamed('replyMessage'),
      )).thenAnswer((_) async => Right(responseMessage));

      // Act
      final result = await sut(params);

      // Assert
      expect(result, Right(responseMessage));
      verify(mockRepository.addMessage(
        roomId: params.roomId,
        message: params.message,
        type: params.type,
        replyMessage: params.replyMessage,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when the repository call fails', () async {
      // Arrange
      const failure = Failure.serverError();
      when(mockRepository.addMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        type: anyNamed('type'),
        replyMessage: anyNamed('replyMessage'),
      )).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await sut(params);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.addMessage(
        roomId: params.roomId,
        message: params.message,
        type: params.type,
        replyMessage: params.replyMessage,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate parameters', () async {
      // Arrange
      const invalidParams = AddMessageParams(
        roomId: '', // Invalid roomId
        message: 'Test message',
        type: MessageType.text,
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
