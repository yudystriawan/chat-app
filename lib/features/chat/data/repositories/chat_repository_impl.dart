import 'dart:developer';
import 'dart:io';

import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/entity.dart';
import '../../domain/reporitories/chat_repository.dart';
import '../datasources/message_remote_datasource.dart';
import '../datasources/room_remote_datasource.dart';
import '../models/message_dtos.dart';
import '../models/room_dtos.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final RoomRemoteDataSource _roomRemoteDataSource;
  final MessageRemoteDataSource _messageRemoteDataSource;

  ChatRepositoryImpl(
    this._roomRemoteDataSource,
    this._messageRemoteDataSource,
  );
  @override
  Future<Either<Failure, Unit>> addEditMessage({
    required String roomId,
    required String message,
    required MessageType type,
    File? image,
    Message? replyMessage,
  }) async {
    try {
      final replyMessageDto =
          replyMessage != null ? MessageDto.fromDomain(replyMessage) : null;

      final data = MessageDto(
        data: message,
        type: type.value,
        replyMessage: replyMessageDto,
      );

      await _messageRemoteDataSource.upsertMessage(
        roomId: roomId,
        message: data,
        image: image,
      );

      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      log(
        'an error occured',
        name: 'addEditMessage',
        error: e,
      );
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, String>> addRoom({
    required KtList<String> membersIds,
    required int type,
  }) async {
    try {
      final bodyRequest = RoomDto(
        members: membersIds.iter.toList(),
        type: type,
      );

      final roomId = await _roomRemoteDataSource.createRoom(bodyRequest);

      return right(roomId);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      log(
        'an error occured',
        name: 'addRoom',
        error: e,
      );

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
    } catch (e) {
      log(
        'an error occured',
        name: 'removeRoom',
        error: e,
      );

      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<Either<Failure, KtList<Room>>> watchChatRooms() {
    return _roomRemoteDataSource.watchRooms().map((rooms) {
      if (rooms == null) {
        return right<Failure, KtList<Room>>(const KtList.empty());
      }

      final data = rooms.map((room) => room.toDomain()).toImmutableList();

      return right<Failure, KtList<Room>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log(
        'an error occured',
        name: 'watchChatRooms',
        error: error,
      );

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, KtList<Member>>> watchMembers(KtList<String> ids) {
    return _roomRemoteDataSource.watchMembers(ids.iter.toList()).map((members) {
      if (members == null) {
        return right<Failure, KtList<Member>>(const KtList.empty());
      }

      final data = members.map((member) => member.toDomain()).toImmutableList();

      return right<Failure, KtList<Member>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log(
        'an error occured',
        name: 'watchMembers',
        error: error,
      );

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, Room>> watchChatRoom(String roomId) {
    return _roomRemoteDataSource.watchRoom(roomId).map((room) {
      if (room == null) {
        return left<Failure, Room>(const Failure.notFound());
      }

      return right<Failure, Room>(room.toDomain());
    }).onErrorReturnWith((error, stackTrace) {
      log(
        'an error occured',
        name: 'watchChatRoom',
        error: error,
      );

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, KtList<Message>>> watchMessages(
    String roomId, {
    int? limit,
  }) {
    return _messageRemoteDataSource
        .fetchMessages(roomId, limit: limit)
        .map((messages) {
      if (messages == null) {
        return right<Failure, KtList<Message>>(const KtList.empty());
      }

      final data = messages.map((e) => e.toDomain()).toImmutableList();
      return right<Failure, KtList<Message>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      log(
        'an error occured',
        name: 'watchMessages',
        error: error,
      );

      if (error is Failure) return left(error);

      return left(const Failure.unexpectedError());
    });
  }

  @override
  Future<Either<Failure, Unit>> enterRoom(String roomId) async {
    try {
      await _roomRemoteDataSource.enterRoom(roomId);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      log(
        'an error occured',
        name: 'enterRoom',
        error: e,
      );
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> exitRoom(String roomId) async {
    try {
      await _roomRemoteDataSource.exitRoom(roomId);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      log(
        'an error occured',
        name: 'exitRoom',
        error: e,
      );
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<Either<Failure, KtList<Message>>> watchUnreadMessages(String roomId) {
    return _messageRemoteDataSource.watchUnreadMessages(roomId).map((messages) {
      if (messages == null) {
        return right<Failure, KtList<Message>>(const KtList.empty());
      }

      final data = messages.map((e) => e.toDomain()).toImmutableList();
      return right<Failure, KtList<Message>>(data);
    }).onErrorReturnWith((error, stackTrace) {
      if (error is Failure) return left(error);

      log(
        'an error occured',
        name: 'getUnreadMessageCount',
        error: error,
      );
      return left(const Failure.unexpectedError());
    });
  }

  @override
  Stream<Either<Failure, Message>> watchLastMessage(String roomId) {
    return _messageRemoteDataSource.watchLastMessage(roomId).map((message) {
      if (message == null) {
        return right<Failure, Message>(Message.empty());
      }

      return right<Failure, Message>(message.toDomain());
    }).onErrorReturnWith((error, stackTrace) {
      if (error is Failure) return left(error);

      log(
        'an error occured',
        name: 'watchLastMessage',
        error: error,
      );
      return left(const Failure.unexpectedError());
    });
  }
}
