import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';
import '../reporitories/chat_repository.dart';

@injectable
class WatchMessages
    implements StreamUsecase<KtList<Message>, WatchMessagesParams> {
  final ChatRepository _repository;

  WatchMessages(this._repository);

  @override
  Stream<Either<Failure, KtList<Message>>> call(params) async* {
    if (params.failure != null) yield* Stream.value(left(params.failure!));

    yield* _repository.watchMessages(
      params.roomId,
      limit: params.limit,
    );
  }
}

class WatchMessagesParams extends Equatable {
  final String roomId;
  final int limit;

  const WatchMessagesParams({
    required this.roomId,
    required this.limit,
  });

  Failure? get failure {
    if (roomId.isEmpty) {
      return const Failure.invalidParameter(message: 'RoomId cannot be empty.');
    }

    if (limit == 0 || limit <= 0) {
      return const Failure.invalidParameter(
          message: 'limit must greater than 0');
    }
    return null;
  }

  @override
  List<Object> get props => [roomId];
}
