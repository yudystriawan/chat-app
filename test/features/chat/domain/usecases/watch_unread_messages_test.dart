import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_unread_messages.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_unread_messages_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchUnreadMessages sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = WatchUnreadMessages(mockRepository);
  });

  const testRoomId = 'testRoomId';
  final testUnreadMessages = KtList.of(
    const Message(
      data: 'sent',
      id: 'id',
      imageUrl: '',
      readInfoList: KtList.empty(),
      sentBy: 'userId1',
      type: MessageType.text,
    ),
    const Message(
      data: 'sent',
      id: 'id',
      imageUrl: '',
      readInfoList: KtList.empty(),
      sentBy: 'userId1',
      type: MessageType.text,
    ),
  );

  group('WatchUnreadMessages Use Case', () {
    test('should return a list of Unread Messages from the repository',
        () async {
      // Arrange
      when(mockRepository.watchUnreadMessages(testRoomId))
          .thenAnswer((_) => Stream.value(Right(testUnreadMessages)));

      // Act
      final result =
          await sut(const WatchUnreadMessagesParams(roomId: testRoomId)).first;

      // Assert
      expect(result, Right(testUnreadMessages));
      verify(mockRepository.watchUnreadMessages(testRoomId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure from the repository when roomId is empty',
        () async {
      // Arrange
      const failure =
          Failure.invalidParameter(message: 'RoomId cannot be empty.');
      when(mockRepository.watchUnreadMessages(''))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result =
          await sut(const WatchUnreadMessagesParams(roomId: '')).first;

      // Assert
      expect(result, const Left(failure));
      verifyNever(mockRepository.watchUnreadMessages('roomId'));
    });
  });
}
