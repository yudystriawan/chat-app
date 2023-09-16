import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class EnterRoom implements Usecase<Unit, EnterRoomParams> {
  final ChatRepository _chatRepository;

  EnterRoom(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _chatRepository.enterRoom(params.roomId);
  }
}

class EnterRoomParams extends Equatable {
  final String roomId;

  const EnterRoomParams(this.roomId);

  @override
  List<Object> get props => [roomId];
}
