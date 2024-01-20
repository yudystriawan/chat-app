import 'package:chat_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:chat_app/features/chat/data/datasources/room_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/member_dtos.dart';
import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:chat_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:core/services/firestore/firestore_service.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'chat_repository_impl_test.mocks.dart';

@GenerateMocks([
  RoomRemoteDataSource,
  MessageRemoteDataSource,
])
void main() {
  late ChatRepositoryImpl sut;
  late MockRoomRemoteDataSource mockRoomRemoteDataSource;
  late MockMessageRemoteDataSource mockMessageRemoteDataSource;

  setUp(() {
    mockRoomRemoteDataSource = MockRoomRemoteDataSource();
    mockMessageRemoteDataSource = MockMessageRemoteDataSource();
    sut = ChatRepositoryImpl(
      mockRoomRemoteDataSource,
      mockMessageRemoteDataSource,
    );
  });

  group('addEditMessage', () {
    test('should add/edit a message successfully', () async {
      // Mock data and expectations
      when(mockMessageRemoteDataSource.upsertMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).thenAnswer((_) => Future.value());

      // Act
      final result = await sut.addEditMessage(
        roomId: 'mockRoomId',
        message: 'Hello!',
        type: MessageType.text,
      );

      // Assert
      expect(result, right(unit));
      verify(mockMessageRemoteDataSource.upsertMessage(
        roomId: 'mockRoomId',
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).called(1);
    });

    test('should handle failure during add/edit message', () async {
      // Mock data and expectations for a failure
      when(mockMessageRemoteDataSource.upsertMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).thenThrow(const Failure.serverError());

      // Act
      final result = await sut.addEditMessage(
        roomId: 'mockRoomId',
        message: 'Hello!',
        type: MessageType.text,
      );

      // Assert
      expect(result, left(const Failure.serverError()));
      verify(mockMessageRemoteDataSource.upsertMessage(
        roomId: 'mockRoomId',
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).called(1);
    });

    test('should handle unexpected error during add/edit message', () async {
      // Mock data and expectations for an unexpected error
      when(mockMessageRemoteDataSource.upsertMessage(
        roomId: anyNamed('roomId'),
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).thenThrow(Exception());

      // Act
      final result = await sut.addEditMessage(
        roomId: 'mockRoomId',
        message: 'Hello!',
        type: MessageType.text,
      );

      // Assert
      expect(result, left(const Failure.unexpectedError()));
      verify(mockMessageRemoteDataSource.upsertMessage(
        roomId: 'mockRoomId',
        message: anyNamed('message'),
        image: anyNamed('image'),
      )).called(1);
    });
  });

  group('addRoom', () {
    test('should add a room successfully', () async {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).thenAnswer((_) => Future.value('mockRoomId'));

      // Act
      final result = await sut.addRoom(
        membersIds: KtList.of('member1', 'member2'),
        type: 1,
      );

      // Assert
      expect(result, right('mockRoomId'));
      verify(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).called(1);
    });

    test('should handle failure during add room', () async {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).thenThrow(const Failure.serverError());

      // Act
      final result = await sut.addRoom(
        membersIds: KtList.of('member1', 'member2'),
        type: 1,
      );

      // Assert
      expect(result, left(const Failure.serverError()));
      verify(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).called(1);
    });

    test('should handle unexpected error during add room', () async {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).thenThrow(Exception());

      // Act
      final result = await sut.addRoom(
        membersIds: KtList.of('member1', 'member2'),
        type: 1,
      );

      // Assert
      expect(result, left(const Failure.unexpectedError()));
      verify(mockRoomRemoteDataSource.createRoom(
        const RoomDto(
          members: ['member1', 'member2'],
          type: 1,
        ),
      )).called(1);
    });
  });

  group('removeRoom', () {
    test('should remove a room successfully', () async {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.deleteRoom('mockRoomId'))
          .thenAnswer((_) => Future.value());

      // Act
      final result = await sut.removeRoom('mockRoomId');

      // Assert
      expect(result, right(unit));
      verify(mockRoomRemoteDataSource.deleteRoom('mockRoomId')).called(1);
    });

    test('should handle failure during remove room', () async {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.deleteRoom('mockRoomId'))
          .thenThrow(const Failure.serverError());

      // Act
      final result = await sut.removeRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.serverError()));
      verify(mockRoomRemoteDataSource.deleteRoom('mockRoomId')).called(1);
    });

    test('should handle unexpected error during remove room', () async {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.deleteRoom('mockRoomId'))
          .thenThrow(Exception());

      // Act
      final result = await sut.removeRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.unexpectedError()));
      verify(mockRoomRemoteDataSource.deleteRoom('mockRoomId')).called(1);
    });
  });

  group('watchChatRooms', () {
    test('should watch chat rooms successfully', () {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.watchRooms()).thenAnswer(
        (_) => Stream.value([
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
        ]),
      );

      // Act
      final result = sut.watchChatRooms();

      // Assert
      expect(result, emits(isA<Either<Failure, KtList<Room>>>()));
      verify(mockRoomRemoteDataSource.watchRooms()).called(1);
    });

    test('should handle failure during chat room watch', () {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.watchRooms())
          .thenAnswer((_) => Stream.error(const Failure.unexpectedError()));

      // Act
      final result = sut.watchChatRooms();

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockRoomRemoteDataSource.watchRooms()).called(1);
    });

    test('should handle unexpected error during chat room watch', () {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.watchRooms())
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchChatRooms();

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockRoomRemoteDataSource.watchRooms()).called(1);
    });
  });

  group('watchMembers', () {
    test('should watch members successfully', () {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .thenAnswer(
        (_) => Stream.value([
          const MemberDto(
            name: 'John',
            imageUrl: 'example.com/john.jpg',
            id: 'member1',
          ),
          const MemberDto(
            name: 'John',
            imageUrl: 'example.com/john.jpg',
            id: 'member2',
          )
        ]),
      );

      // Act
      final result = sut.watchMembers(KtList.of('member1', 'member2'));

      // Assert
      expect(result, emits(isA<Either<Failure, KtList<Member>>>()));
      verify(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .called(1);
    });

    test('should handle failure during member watch', () {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchMembers(KtList.of('member1', 'member2'));

      // Assert
      expect(result, emits(left(const Failure.serverError())));
      verify(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .called(1);
    });

    test('should handle unexpected error during member watch', () {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchMembers(KtList.of('member1', 'member2'));

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockRoomRemoteDataSource.watchMembers(['member1', 'member2']))
          .called(1);
    });
  });

  group('watchChatRoom', () {
    test('should watch a chat room successfully', () {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.watchRoom('mockRoomId')).thenAnswer(
        (_) => Stream.value(RoomDto(
          id: '123',
          members: ['user1', 'user2'],
          type: 1,
          name: 'Test Room',
          description: 'This is a test room',
          imageUrl: 'http://example.com/image.jpg',
          createdBy: 'user1',
          createdAt: ServerTimestamp.create(),
        )),
      );

      // Act
      final result = sut.watchChatRoom('mockRoomId');

      // Assert
      expect(result, emits(isA<Either<Failure, Room>>()));
      verify(mockRoomRemoteDataSource.watchRoom('mockRoomId')).called(1);
    });

    test('should handle failure during chat room watch', () {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.watchRoom('mockRoomId'))
          .thenAnswer((_) => Stream.error(const Failure.notFound()));

      // Act
      final result = sut.watchChatRoom('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.notFound())));
      verify(mockRoomRemoteDataSource.watchRoom('mockRoomId')).called(1);
    });

    test('should handle unexpected error during chat room watch', () {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.watchRoom('mockRoomId'))
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchChatRoom('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockRoomRemoteDataSource.watchRoom('mockRoomId')).called(1);
    });
  });

  group('watchMessages', () {
    test('should watch messages successfully', () {
      // Mock data and expectations
      when(mockMessageRemoteDataSource.fetchMessages('mockRoomId', limit: null))
          .thenAnswer(
        (_) => Stream.value([
          MessageDto(
            id: '1',
            data: 'Hello, World!',
            type: 'text',
            sentBy: 'user1',
            sentAt: ServerTimestamp.create(),
            imageUrl: 'https://example.com/image.jpg',
            replyMessage: null,
            readBy: {'user1': true, 'user2': false},
          )
        ]),
      );

      // Act
      final result = sut.watchMessages('mockRoomId');

      // Assert
      expect(result, emits(isA<Either<Failure, KtList<Message>>>()));
      verify(mockMessageRemoteDataSource.fetchMessages('mockRoomId',
              limit: null))
          .called(1);
    });

    test('should handle failure during message watch', () {
      // Mock data and expectations for a failure
      when(mockMessageRemoteDataSource.fetchMessages('mockRoomId', limit: null))
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchMessages('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.serverError())));
      verify(mockMessageRemoteDataSource.fetchMessages('mockRoomId',
              limit: null))
          .called(1);
    });

    test('should handle unexpected error during message watch', () {
      // Mock data and expectations for an unexpected error
      when(mockMessageRemoteDataSource.fetchMessages('mockRoomId', limit: null))
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchMessages('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockMessageRemoteDataSource.fetchMessages('mockRoomId',
              limit: null))
          .called(1);
    });
  });

  group('enterRoom', () {
    test('should enter a room successfully', () async {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.enterRoom('mockRoomId'))
          .thenAnswer((_) => Future.value());

      // Act
      final result = await sut.enterRoom('mockRoomId');

      // Assert
      expect(result, right(unit));
      verify(mockRoomRemoteDataSource.enterRoom('mockRoomId')).called(1);
    });

    test('should handle failure during entering room', () async {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.enterRoom('mockRoomId'))
          .thenThrow(const Failure.serverError());

      // Act
      final result = await sut.enterRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.serverError()));
      verify(mockRoomRemoteDataSource.enterRoom('mockRoomId')).called(1);
    });

    test('should handle unexpected error during entering room', () async {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.enterRoom('mockRoomId'))
          .thenThrow(Exception());

      // Act
      final result = await sut.enterRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.unexpectedError()));
      verify(mockRoomRemoteDataSource.enterRoom('mockRoomId')).called(1);
    });
  });

  group('exitRoom', () {
    test('should exit a room successfully', () async {
      // Mock data and expectations
      when(mockRoomRemoteDataSource.exitRoom('mockRoomId'))
          .thenAnswer((_) => Future.value());

      // Act
      final result = await sut.exitRoom('mockRoomId');

      // Assert
      expect(result, right(unit));
      verify(mockRoomRemoteDataSource.exitRoom('mockRoomId')).called(1);
    });

    test('should handle failure during exiting room', () async {
      // Mock data and expectations for a failure
      when(mockRoomRemoteDataSource.exitRoom('mockRoomId'))
          .thenThrow(const Failure.serverError());

      // Act
      final result = await sut.exitRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.serverError()));
      verify(mockRoomRemoteDataSource.exitRoom('mockRoomId')).called(1);
    });

    test('should handle unexpected error during exiting room', () async {
      // Mock data and expectations for an unexpected error
      when(mockRoomRemoteDataSource.exitRoom('mockRoomId'))
          .thenThrow(Exception());

      // Act
      final result = await sut.exitRoom('mockRoomId');

      // Assert
      expect(result, left(const Failure.unexpectedError()));
      verify(mockRoomRemoteDataSource.exitRoom('mockRoomId')).called(1);
    });
  });

  group('watchUnreadMessages', () {
    test('should watch unread messages successfully', () {
      // Mock data and expectations
      when(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .thenAnswer(
        (_) => Stream.value([
          MessageDto(
            id: '1',
            data: 'Hello, World!',
            type: 'text',
            sentBy: 'user1',
            sentAt: ServerTimestamp.create(),
            imageUrl: 'https://example.com/image.jpg',
            replyMessage: null,
            readBy: {'user1': true, 'user2': false},
          )
        ]),
      );

      // Act
      final result = sut.watchUnreadMessages('mockRoomId');

      // Assert
      expect(result, emits(isA<Either<Failure, KtList<Message>>>()));
      verify(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .called(1);
    });

    test('should handle failure during unread message watch', () {
      // Mock data and expectations for a failure
      when(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchUnreadMessages('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.serverError())));
      verify(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .called(1);
    });

    test('should handle unexpected error during unread message watch', () {
      // Mock data and expectations for an unexpected error
      when(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchUnreadMessages('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockMessageRemoteDataSource.watchUnreadMessages('mockRoomId'))
          .called(1);
    });
  });

  group('watchLastMessage', () {
    test('should watch the last message successfully', () {
      // Mock data and expectations
      when(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .thenAnswer(
        (_) => Stream.value(MessageDto(
          id: '1',
          data: 'Hello, World!',
          type: 'text',
          sentBy: 'user1',
          sentAt: ServerTimestamp.create(),
          imageUrl: 'https://example.com/image.jpg',
          replyMessage: null,
          readBy: {'user1': true, 'user2': false},
        )),
      );

      // Act
      final result = sut.watchLastMessage('mockRoomId');

      // Assert
      expect(result, emits(isA<Either<Failure, Message>>()));
      verify(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .called(1);
    });

    test('should handle failure during last message watch', () {
      // Mock data and expectations for a failure
      when(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchLastMessage('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.serverError())));
      verify(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .called(1);
    });

    test('should handle unexpected error during last message watch', () {
      // Mock data and expectations for an unexpected error
      when(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchLastMessage('mockRoomId');

      // Assert
      expect(result, emits(left(const Failure.unexpectedError())));
      verify(mockMessageRemoteDataSource.watchLastMessage('mockRoomId'))
          .called(1);
    });
  });
}
