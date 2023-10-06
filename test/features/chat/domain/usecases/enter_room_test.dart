import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/enter_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'enter_room_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late EnterRoom sut;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sut = EnterRoom(mockChatRepository);
  });

  group('EnterRoom Use Case', () {
    const roomId = 'exampleRoomId';

    test('should enter the room when called with valid parameters', () async {
      // Arrange
      when(mockChatRepository.enterRoom(roomId))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(const EnterRoomParams(roomId));

      // Assert
      expect(result, const Right(unit));
      verify(mockChatRepository.enterRoom(roomId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return a failure when called with an invalid parameter',
        () async {
      // Arrange
      const invalidRoomId = '';
      const expectedFailure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');

      // Act
      final result = await sut(const EnterRoomParams(invalidRoomId));

      // Assert
      expect(result, const Left(expectedFailure));
      verifyZeroInteractions(mockChatRepository);
    });

    test('should return a failure when called with an empty roomId', () async {
      // Arrange
      const emptyRoomId = '';
      const expectedFailure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');

      // Act
      final result = await sut(const EnterRoomParams(emptyRoomId));

      // Assert
      expect(result, const Left(expectedFailure));
      verifyZeroInteractions(mockChatRepository);
    });
  });
}
