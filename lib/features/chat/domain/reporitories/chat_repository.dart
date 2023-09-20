import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
    required MessageType type,
  });
  Future<Either<Failure, String>> addRoom({
    required KtList<String> members,
    required int type,
  });
  Future<Either<Failure, Unit>> removeRoom(String roomId);
  Stream<Either<Failure, KtList<Room>>> getChatRooms();
  Stream<Either<Failure, Room>> getChatRoom(String roomId);
  Stream<Either<Failure, KtList<Member>>> getMembers(KtList<String> ids);
  Stream<Either<Failure, KtList<Message>>> getMessages(
    String roomId, {
    int? limit,
  });

  /// this function is to notify the room
  /// when user is in this room, all message that does not read will be read.
  Future<Either<Failure, Unit>> enterRoom(String roomId);

  /// this function is to notify the room that user exit
  /// so messages in this room will not change to read
  Future<Either<Failure, Unit>> exitRoom(String roomId);

  Stream<Either<Failure, KtList<Message>>> getUnreadMessages(String roomId);

  Stream<Either<Failure, Message>> watchLastMessage(String roomId);
}
