import 'dart:io';

import 'package:chat_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/services/storage/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'message_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  FirestoreService,
  StorageService,
  User,
])
void main() {
  late MessageRemoteDataSourceImpl sut;
  late MockFirestoreService mockFirestoreService;
  late MockAuthService mockAuthService;
  late MockStorageService mockStorageService;

  final user = MockUser();
  const messageId = 'messageId';
  const downloadUrl = 'https://image.jpg';

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    mockStorageService = MockStorageService();
    sut = MessageRemoteDataSourceImpl(
      mockFirestoreService,
      mockAuthService,
      mockStorageService,
    );

    when(user.uid).thenReturn('user1');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');

    when(mockAuthService.currentUser).thenReturn(user);
    when(mockFirestoreService.generateId()).thenReturn(messageId);
    when(mockStorageService.uploadImage(
      fullPath: anyNamed('fullPath'),
      image: anyNamed('image'),
      metadata: anyNamed('metadata'),
    )).thenAnswer((_) async => downloadUrl);
  });

  group('upsertMessage', () {
    test('should create a message successfully', () async {
      // Arrange
      const roomId = 'roomId';
      const messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        readBy: {'user1': true, 'user2': false},
      );

      // Act
      await sut.upsertMessage(roomId: roomId, message: messageDto);

      // Assert
      verify(mockFirestoreService.upsert(any, any, any)).called(1);
      verifyZeroInteractions(mockStorageService);
    });

    test('should create a message with an image successfully', () async {
      // Arrange
      const roomId = 'roomId';
      const messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'image',
        sentBy: 'user1',
        readBy: {'user1': true, 'user2': false},
      );
      final imageFile = File('path/to/image.jpg');

      // Act
      await sut.upsertMessage(
        roomId: roomId,
        message: messageDto,
        image: imageFile,
      );

      // Assert
      verifyInOrder([
        mockStorageService.uploadImage(
          fullPath: anyNamed('fullPath'),
          image: anyNamed('image'),
        ),
        mockFirestoreService.upsert(any, any, any),
      ]);
    });

    test('should throw a server error on failure', () async {
      // Arrange
      const roomId = 'roomId';
      const messageDto = MessageDto();

      when(mockFirestoreService.upsert(any, any, any)).thenThrow(
        const Failure.serverError(),
      );

      // Act & Assert
      expect(
        () => sut.upsertMessage(roomId: roomId, message: messageDto),
        throwsA(const TypeMatcher<Failure>()),
      );
    });
  });

  group('fetchMessages', () {
    const roomId = 'roomId';
    const limit = 10;

    final messagesList = [
      MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: ServerTimestamp.create(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': false, 'user2': true},
      ),
      MessageDto(
        id: '2',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user2',
        sentAt: ServerTimestamp.create(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': true, 'user2': false},
      ),
    ];
    test('should fetch messages successfully', () async {
      // Arrange
      when(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
        orConditions: anyNamed('orConditions'),
        whereConditions: anyNamed('whereConditions'),
      )).thenAnswer((_) => Stream.value(
          messagesList.map((message) => message.toJson()).toList()));

      // Act
      final result = sut.fetchMessages(roomId, limit: limit);

      // Assert
      await expectLater(result, emitsInOrder([messagesList]));

      verify(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).called(1);
    });

    test('should throw a server error on failure', () async {
      // Arrange
      const roomId = 'roomId';
      const limit = 10;

      when(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).thenThrow(const Failure.serverError());

      // Act & Assert
      await expectLater(() => sut.fetchMessages(roomId, limit: limit),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('watchUnreadMessages', () {
    test('should watch unread messages successfully', () async {
      // Arrange
      const roomId = 'roomId';

      final unreadMessagesList = [
        MessageDto(
          id: '1',
          data: 'Hello, World!',
          type: 'text',
          sentBy: 'user1',
          sentAt: ServerTimestamp.create(),
          imageUrl: 'https://example.com/image.jpg',
          replyMessage: null,
          readBy: {'user1': false, 'user2': true},
        ),
        MessageDto(
          id: '2',
          data: 'Hello, World!',
          type: 'text',
          sentBy: 'user2',
          sentAt: ServerTimestamp.create(),
          imageUrl: 'https://example.com/image.jpg',
          replyMessage: null,
          readBy: {'user1': true, 'user2': false},
        ),
      ];

      when(mockFirestoreService.watchAll(
        any,
        whereConditions: anyNamed('whereConditions'),
        orConditions: anyNamed('orConditions'),
      )).thenAnswer((_) => Stream.value(
          unreadMessagesList.map((message) => message.toJson()).toList()));

      // Act
      final result = sut.watchUnreadMessages(roomId);

      // Assert
      await expectLater(result, emits(unreadMessagesList));

      verify(mockAuthService.currentUser).called(1);
      verify(mockFirestoreService.watchAll(
        any,
        whereConditions: anyNamed('whereConditions'),
        orConditions: anyNamed('orConditions'),
      )).called(1);
    });

    test('should throw a server error on failure', () async {
      // Arrange
      const roomId = 'roomId';

      when(mockFirestoreService.watchAll(
        any,
        whereConditions: anyNamed('whereConditions'),
        orConditions: anyNamed('orConditions'),
      )).thenThrow(const Failure.serverError());

      // Act & Assert
      await expectLater(() => sut.watchUnreadMessages(roomId),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('watchLastMessage', () {
    test('should watch the last message successfully', () async {
      // Arrange
      const roomId = 'roomId';

      final lastMessage = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: ServerTimestamp.create(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': false, 'user2': true},
      );

      when(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) => Stream.value([lastMessage.toJson()]));

      // Act
      final result = sut.watchLastMessage(roomId);

      // Assert
      await expectLater(result, emits(lastMessage));

      verify(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      ));
    });

    test('should return null if no last message found', () async {
      // Arrange
      const roomId = 'roomId';

      when(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).thenAnswer((_) => Stream.value([]));

      // Act
      final result = sut.watchLastMessage(roomId);

      // Assert
      await expectLater(result, emits(null));

      verify(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).called(1);
    });

    test('should throw a server error on failure', () async {
      // Arrange
      const roomId = 'roomId';

      when(mockFirestoreService.watchAll(
        any,
        orderConditions: anyNamed('orderConditions'),
        limit: anyNamed('limit'),
      )).thenThrow(const Failure.serverError());

      // Act & Assert
      await expectLater(() => sut.watchLastMessage(roomId),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('fetchMessage', () {
    test('should fetch a message successfully', () async {
      // Arrange
      const roomId = 'roomId';
      const messageId = 'messageId';

      final messageDto = MessageDto(
        id: '1',
        data: 'Hello, World!',
        type: 'text',
        sentBy: 'user1',
        sentAt: ServerTimestamp.create(),
        imageUrl: 'https://example.com/image.jpg',
        replyMessage: null,
        readBy: {'user1': false, 'user2': true},
      );

      when(mockFirestoreService.watch(
        any,
        any,
      )).thenAnswer((_) => Stream.value(messageDto.toJson()));

      // Act
      final result = await sut.fetchMessage(
        roomId: roomId,
        messageId: messageId,
      );

      // Assert
      expect(result, equals(messageDto));

      verify(mockFirestoreService.watch(
        any,
        any,
      )).called(1);
    });

    test('should throw a server error on failure', () async {
      // Arrange
      const roomId = 'roomId';
      const messageId = 'messageId';

      when(mockFirestoreService.watch(
        any,
        any,
      )).thenThrow(const Failure.serverError());

      // Act & Assert
      expect(
        () => sut.fetchMessage(roomId: roomId, messageId: messageId),
        throwsA(const TypeMatcher<Failure>()),
      );
    });
  });
}
