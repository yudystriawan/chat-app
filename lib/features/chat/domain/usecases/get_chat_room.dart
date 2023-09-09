import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';

@injectable
class GetChatRoom implements StreamUsecase<Room, GetChatRoomParams> {
  final ChatRepository _repository;

  GetChatRoom(this._repository);

  @override
  Stream<Either<Failure, Room>> call(params) {
    return _repository.getChatRoom(params.roomId);
  }
}

class GetChatRoomParams extends Equatable {
  final String roomId;

  const GetChatRoomParams({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}
