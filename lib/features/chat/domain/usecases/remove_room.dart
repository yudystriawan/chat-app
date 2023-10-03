import '../reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveRoom implements Usecase<Unit, DeleteRoomParams> {
  final ChatRepository _repository;

  RemoveRoom(this._repository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _repository.removeRoom(params.roomId);
  }
}

class DeleteRoomParams extends Equatable {
  final String roomId;

  const DeleteRoomParams(this.roomId);

  @override
  List<Object> get props => [roomId];
}
