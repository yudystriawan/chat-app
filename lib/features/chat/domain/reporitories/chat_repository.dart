import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
  });
  Future<Either<Failure, String>> addRoom({
    required KtList<String> userIds,
    required int type,
  });
  Future<Either<Failure, Unit>> removeRoom(String roomId);
}
