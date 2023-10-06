import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/remove_room.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_room_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late RemoveRoom sut;
  late MockChatRepository mockChatRepository;

  setUp(() {
    mockChatRepository = MockChatRepository();
    sut = RemoveRoom(mockChatRepository);
  });

  group('RemoveRoom Use Case', () {
    const roomId = 'exampleRoomId';

    test('should remove the room when called with valid parameters', () async {
      // Arrange
      when(mockChatRepository.removeRoom(roomId))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(const RemoveRoomParams(roomId));

      // Assert
      expect(result, const Right(unit));
      verify(mockChatRepository.removeRoom(roomId)).called(1);
      verifyNoMoreInteractions(mockChatRepository);
    });

    test('should return a failure when called with an invalid parameter',
        () async {
      // Arrange
      const invalidRoomId = '';
      const expectedFailure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');

      // Act
      final result = await sut(const RemoveRoomParams(invalidRoomId));

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
      final result = await sut(const RemoveRoomParams(emptyRoomId));

      // Assert
      expect(result, const Left(expectedFailure));
      verifyZeroInteractions(mockChatRepository);
    });
  });
}
