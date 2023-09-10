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
}
