import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/reporitories/chat_repository.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  @override
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
  }) {
    // TODO: implement createMessage
    throw UnimplementedError();
  }
}
