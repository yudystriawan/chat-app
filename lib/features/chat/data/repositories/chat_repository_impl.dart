import 'dart:developer';

import 'package:chat_app/features/chat/data/datasources/message_remote_datasource.dart';
import 'package:chat_app/features/chat/data/datasources/room_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/entity.dart';
import '../../domain/reporitories/chat_repository.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final RoomRemoteDataSource _roomRemoteDataSource;
  final MessageRemoteDataSource _messageRemoteDataSource;

  ChatRepositoryImpl(
    this._roomRemoteDataSource,
    this._messageRemoteDataSource,
  );
  @override
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
    required MessageType type,
  }) async {
    try {
      final data = MessageDto(
        data: message,
        type: type.value,
      );

      await _messageRemoteDataSource.createMessage(
        roomId: roomId,
        message: data,
      );

      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e, s) {
      log('createMessage', error: e, stackTrace: s);
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, String>> addRoom({
    required KtList<String> members,
    required int type,
  }) async {
    try {
      final bodyRequest = RoomDto(
        members: members.iter.toList(),
        type: type,
      );

      final roomId = await _roomRemoteDataSource.createRoom(bodyRequest);

      return right(roomId);
    } on Failure catch (e) {
      return left(e);
    } catch (e, s) {
      log('addRoom', error: e, stackTrace: s);

      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeRoom(String roomId) async {
    try {
      await _roomRemoteDataSource.deleteRoom(roomId);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e, s) {
      log('removeRoom', error: e, stackTrace: s);

      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<Either<Failure, KtList<Room>>> getChatRooms() {
    return _roomRemoteDataSource.fetchRooms().map((rooms) {
      if (rooms == null) {
        return right<Failure, KtList<Room>>(const KtList.empty());
      }

      final data = rooms.map((room) => room.toDomain()).toImmutableList();

      return right<Failure, KtList<Room>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log('getChatRooms', error: error, stackTrace: stackTrace);

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, KtList<Member>>> getMembers(KtList<String> ids) {
    return _roomRemoteDataSource.fetchMembers(ids.iter.toList()).map((members) {
      if (members == null) {
        return right<Failure, KtList<Member>>(const KtList.empty());
      }

      final data = members.map((member) => member.toDomain()).toImmutableList();

      return right<Failure, KtList<Member>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log('getMembers', error: error, stackTrace: stackTrace);

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, Room>> getChatRoom(String roomId) {
    return _roomRemoteDataSource.fetchRoom(roomId).map((room) {
      if (room == null) {
        return left<Failure, Room>(const Failure.notFound());
      }

      return right<Failure, Room>(room.toDomain());
    }).onErrorReturnWith((error, stackTrace) {
      log('getChatRoom', error: error, stackTrace: stackTrace);

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, KtList<Message>>> getMessages(String roomId) {
    return _messageRemoteDataSource.fetchMessages(roomId).map((messages) {
      if (messages == null) {
        return right<Failure, KtList<Message>>(const KtList.empty());
      }

      final data = messages.map((e) => e.toDomain()).toImmutableList();
      return right<Failure, KtList<Message>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log('getMessages', error: error, stackTrace: stackTrace);

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }
}
