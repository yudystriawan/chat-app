import '../reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';

@injectable
class WatchChatRoom implements StreamUsecase<Room, WatchChatRoomParams> {
  final ChatRepository _repository;

  WatchChatRoom(this._repository);

  @override
  Stream<Either<Failure, Room>> call(params) {
    return _repository.watchChatRoom(params.roomId);
  }
}

class WatchChatRoomParams extends Equatable {
  final String roomId;

  const WatchChatRoomParams({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}
