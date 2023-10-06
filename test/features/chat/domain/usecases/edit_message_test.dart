import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/edit_message.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_message_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late EditMessage sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = EditMessage(mockRepository);
  });

  group('EditMessage Use Case', () {
    const testRoomId = 'testRoomId';

    final testMessage = Message(
      id: 'messageId',
      data: 'Test message',
      imageUrl: '',
      readInfoList: const KtList.empty(),
      sentBy: 'userId',
      type: MessageType.text,
      sentAt: DateTime.now(),
    );

    final testParams = EditMessageParams(
      roomId: testRoomId,
      message: testMessage,
    );

    test('should edit a message in the repository', () async {
      // Arrange
      when(mockRepository.editMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
      )).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(testParams);

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.editMessage(
        roomId: testRoomId,
        message: testMessage,
      )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when editing fails', () async {
      // Arrange
      when(mockRepository.editMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
      )).thenAnswer((_) async => const Left(Failure.serverError()));

      // Act
      final result = await sut(testParams);

      // Assert
      expect(result, const Left(Failure.serverError()));
      verify(mockRepository.editMessage(
              roomId: testRoomId, message: testMessage))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure when roomId is empty', () async {
      // Arrange
      const emptyRoomId = '';
      final testParams = EditMessageParams(
        roomId: emptyRoomId,
        message: testMessage,
      );

      // Act
      final result = await sut(testParams);

      // Assert
      expect(
        result,
        const Left(
            Failure.invalidParameter(message: 'Room Id cannot be empty.')),
      );
      verifyNever(mockRepository.editMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
      ));
    });

    test('should return a Failure when message is empty', () async {
      // Arrange
      const roomId = 'roomId';
      final testParams = EditMessageParams(
        roomId: roomId,
        message: Message.empty(),
      );

      // Act
      final result = await sut(testParams);

      // Assert
      expect(
        result,
        const Left(Failure.invalidParameter(message: 'Message is not valid.')),
      );
      verifyNever(mockRepository.editMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
      ));
    });
  });
}
