import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../reporitories/chat_repository.dart';

@injectable
class EnterRoom implements Usecase<Unit, EnterRoomParams> {
  final ChatRepository _chatRepository;

  EnterRoom(this._chatRepository);

  @override
  Future<Either<Failure, Unit>> call(params) async {
    if (params.failure != null) return left(params.failure!);

    return _chatRepository.enterRoom(params.roomId);
  }
}

class EnterRoomParams extends Equatable {
  final String roomId;

  const EnterRoomParams(this.roomId);

  Failure? get failure {
    if (roomId.isEmpty) {
      return const Failure.invalidParameter(message: 'RoomId cannot be empty.');
    }
    return null;
  }

  @override
  List<Object> get props => [roomId];
}
