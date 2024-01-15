import 'package:chat_app/features/chat/data/datasources/room_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/member_dtos.dart';
import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/services/firestore/firestore_service.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'room_remote_datasource_test.mocks.dart';

@GenerateMocks([
  FirestoreService,
  AuthService,
  User,
])
void main() {
  late RoomRemoteDataSource dataSource;
  late MockFirestoreService mockFirestoreService;
  late MockAuthService mockAuthService;

  final user = MockUser();

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    dataSource =
        RoomRemoteDataSourceImpl(mockFirestoreService, mockAuthService);

    when(user.uid).thenReturn('user1');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');
  });
  group('createRoom', () {
    test('should create a room successfully', () async {
      final roomDto = RoomDto(
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: ServerTimestamp.create(),
      );

      // Mock data and expectations
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenAnswer((_) => Stream.value([]));
      when(mockFirestoreService.generateId()).thenReturn('123');
      when(mockFirestoreService.upsert(any, any, any))
          .thenAnswer((_) => Future.value());

      // Act
      final result = await dataSource.createRoom(roomDto);

      // Assert
      expect(result, '123');
      verify(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .called(1);
      verify(mockFirestoreService.generateId()).called(1);
      verify(mockFirestoreService.upsert(any, any, any)).called(1);
    });

    test('should return existing room ID if room already exists', () async {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: ServerTimestamp.create(),
      );

      // Mock data and expectations
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenAnswer((_) => Stream.value([roomDto.toJson()]));

      // Act
      final result = await dataSource.createRoom(roomDto);

      // Assert
      expect(result, isNotNull);
      verify(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .called(1);
      verifyNever(mockFirestoreService.generateId());
      verifyNever(mockFirestoreService.upsert(any, any, any));
    });

    test('should handle server error during room creation', () async {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: ServerTimestamp.create(),
      );
      // Mock data and expectations for a server error
      when(mockAuthService.currentUser).thenThrow(Exception());

      // Act and Assert
      expect(() async => await dataSource.createRoom(roomDto),
          throwsA(isA<Failure>()));
    });
  });

  group('deleteRoom', () {
    test('should delete a room successfully', () async {
      // Mock data and expectations
      when(mockFirestoreService.delete(any, any))
          .thenAnswer((_) => Future.value());

      // Act
      await dataSource.deleteRoom('mockRoomId');

      // Assert
      verify(mockFirestoreService.delete(any, any)).called(1);
    });

    test('should handle server error during room deletion', () async {
      // Mock data and expectations for a server error
      when(mockFirestoreService.delete(any, any)).thenThrow(Exception());

      // Act and Assert
      expect(() async => await dataSource.deleteRoom('mockRoomId'),
          throwsA(isA<Failure>()));
    });
  });

  group('watchRooms', () {
    test('should watch rooms successfully', () async {
      final listRoomDto = [
        RoomDto(
          id: '123',
          members: ['user1', 'user2'],
          type: 1,
          name: 'Test Room',
          description: 'This is a test room',
          imageUrl: 'http://example.com/image.jpg',
          createdBy: 'user1',
          createdAt: ServerTimestamp.create(),
        )
      ];
      // Mock data and expectations
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenAnswer(
              (_) => Stream.value(listRoomDto.map((e) => e.toJson()).toList()));

      // Act
      final result = dataSource.watchRooms();

      // Assert
      await expectLater(result, emits(listRoomDto));
      verify(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .called(1);
    });

    test('should handle server error during room watch', () {
      // Mock data and expectations for a server error
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenThrow(const Failure.serverError());

      // Act and Assert
      expectLater(
          () => dataSource.watchRooms(), throwsA(const TypeMatcher<Failure>()));
    });
  });
  group('watchRoom', () {
    test('should watch a room successfully', () async {
      final roomDto = RoomDto(
        id: '123',
        members: ['user1', 'user2'],
        type: 1,
        name: 'Test Room',
        description: 'This is a test room',
        imageUrl: 'http://example.com/image.jpg',
        createdBy: 'user1',
        createdAt: ServerTimestamp.create(),
      );
      // Mock data and expectations
      when(mockFirestoreService.watch(any, any))
          .thenAnswer((_) => Stream.value(roomDto.toJson()));

      // Act
      final result = dataSource.watchRoom('mockRoomId');

      // Assert
      await expectLater(result, emits(isA<RoomDto?>()));
      verify(mockFirestoreService.watch(any, any)).called(1);
    });

    test('should handle server error during room watch', () {
      // Mock data and expectations for a server error
      when(mockFirestoreService.watch(any, any))
          .thenThrow(const Failure.serverError());

      // Act and Assert
      expectLater(() => dataSource.watchRoom('mockRoomId'),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('watchMembers', () {
    final memberJson = {
      'name': 'John',
      'photoUrl': 'example.com/john.jpg',
      'id': '12345',
    };

    test('should watch members successfully', () async {
      // Mock data and expectations
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenAnswer((_) => Stream.value([memberJson]));

      // Act
      final result = dataSource.watchMembers(['mockUserId']);

      // Assert
      await expectLater(result, emits(isA<List<MemberDto>?>()));
      verify(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .called(1);
    });

    test('should handle server error during member watch', () {
      // Mock data and expectations for a server error
      when(mockFirestoreService.watchAll(any,
              whereConditions: anyNamed('whereConditions')))
          .thenThrow(const Failure.serverError());

      // Act and Assert
      expectLater(() => dataSource.watchMembers(['mockUserId']),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('enterRoom', () {
    test('should enter room successfully', () async {
      // Mock data and expectations
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.upsert(any, any, any))
          .thenAnswer((_) => Future.value());

      // Act
      await dataSource.enterRoom('mockRoomId');

      // Assert
      verify(mockFirestoreService.upsert(any, any, any)).called(1);
    });

    test('should handle server error during entering room', () async {
      // Mock data and expectations for a server error
      when(mockAuthService.currentUser).thenThrow(Exception());

      // Act and Assert
      expect(() async => await dataSource.enterRoom('mockRoomId'),
          throwsA(isA<Failure>()));
    });
  });

  group('exitRoom', () {
    test('should exit room successfully', () async {
      // Mock data and expectations
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.upsert(any, any, any))
          .thenAnswer((_) => Future.value());

      // Act
      await dataSource.exitRoom('mockRoomId');

      // Assert
      verify(mockFirestoreService.upsert(any, any, any)).called(1);
    });

    test('should handle server error during exiting room', () async {
      // Mock data and expectations for a server error
      when(mockAuthService.currentUser).thenThrow(Exception());

      // Act and Assert
      expect(() async => await dataSource.exitRoom('mockRoomId'),
          throwsA(isA<Failure>()));
    });
  });
}
