import 'package:core/core.dart';
import 'package:dartz/dartz.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
  });
}
