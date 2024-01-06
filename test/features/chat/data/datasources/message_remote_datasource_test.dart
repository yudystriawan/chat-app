import 'package:chat_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  FirestoreService,
  User,
])
void main() {
  late MessageRemoteDataSourceImpl dataSource;
  late MockFirestoreService mockFirestoreService;
  late MockAuthService mockAuthService;
  final user = MockUser();

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    dataSource =
        MessageRemoteDataSourceImpl(mockFirestoreService, mockAuthService);

    when(user.uid).thenReturn('123');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');
  });

  group('createMessage', () {
    test('creates and returns a message successfully', () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.generateId()).thenReturn('message456');

      // Act
      final result = await dataSource.createMessage(
        roomId: 'room123',
        message: MessageDto(
          id: '1',
          data: 'Hello, World!',
          type: 'text',
          sentBy: 'user1',
          sentAt: ServerTimestamp.create(),
          imageUrl: 'https://example.com/image.jpg',
          replyMessage: null,
          readBy: {'user1': true, 'user2': false},
        ),
      );

      // Assert
      expect(result, isA<MessageDto>());
    });

    test('throws a server error if an exception occurs', () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.generateId()).thenReturn('message456');
      when(mockFirestoreService.upsert(any, any, any))
          .thenThrow(Exception('Server error'));

      // Act & Assert
      expect(
          () => dataSource.createMessage(
              roomId: 'room789', message: const MessageDto()),
          throwsA(isA<Failure>()));
    });
  });

  // Repeat similar blocks for other methods like fetchMessages, watchUnreadMessages, etc.
}
