import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../reporitories/chat_repository.dart';

@injectable
class ExitRoom implements Usecase<Unit, ExitRoomParams> {
  final ChatRepository _chatRepository;

  ExitRoom(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _chatRepository.exitRoom(params.roomId);
  }
}

class ExitRoomParams extends Equatable {
  final String roomId;

  const ExitRoomParams(this.roomId);

  @override
  List<Object> get props => [roomId];
}
