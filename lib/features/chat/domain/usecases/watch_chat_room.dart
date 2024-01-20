import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';
import '../reporitories/chat_repository.dart';

@injectable
class WatchChatRoom implements StreamUsecase<Room, WatchChatRoomParams> {
  final ChatRepository _repository;

  WatchChatRoom(this._repository);

  @override
  Stream<Either<Failure, Room>> call(params) async* {
    if (params.failure != null) yield* Stream.value(left(params.failure!));

    yield* _repository.watchChatRoom(params.roomId);
  }
}

class WatchChatRoomParams extends Equatable {
  final String roomId;

  const WatchChatRoomParams({
    required this.roomId,
  });

  Failure? get failure {
    if (roomId.isEmpty) {
      return const Failure.invalidParameter(message: 'RoomId cannot be empty.');
    }
    return null;
  }

  @override
  List<Object> get props => [roomId];
}
