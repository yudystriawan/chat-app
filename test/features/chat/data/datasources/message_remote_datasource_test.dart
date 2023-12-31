import 'package:chat_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  FirestoreService,
])
void main() {
  late MessageRemoteDataSourceImpl dataSource;
  late MockFirestoreService mockFirestoreService;
  late MockAuthService mockAuthService;

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    dataSource =
        MessageRemoteDataSourceImpl(mockFirestoreService, mockAuthService);
  });

  group('createMessage', () {
    test('creates and returns a message successfully', () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(const User(uid: 'user123'));
      when(mockFirestoreService.generateId()).thenReturn('message456');

      // Act
      final result = await dataSource.createMessage(
          roomId: 'room789', message: MessageDto());

      // Assert
      expect(result, isA<MessageDto>());
      // Add more assertions based on your requirements
    });

    test('throws a server error if an exception occurs', () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(const User(uid: 'user123'));
      when(mockFirestoreService.generateId()).thenReturn('message456');
      when(mockFirestoreService.upsert(any, any, any))
          .thenThrow(Exception('Server error'));

      // Act & Assert
      expect(
          () => dataSource.createMessage(
              roomId: 'room789', message: MessageDto()),
          throwsA(isA<Failure>()
              .having((f) => f is Failure.serverError, 'isServerError', true)));
    });
  });

  // Repeat similar blocks for other methods like fetchMessages, watchUnreadMessages, etc.
}
