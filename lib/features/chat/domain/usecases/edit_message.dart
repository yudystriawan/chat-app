import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';

@injectable
class EditMessage implements Usecase<Unit, EditMessageParams> {
  final ChatRepository _repository;

  EditMessage(this._repository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _repository.editMessage(
      roomId: params.roomId,
      message: params.message,
    );
  }
}

class EditMessageParams extends Equatable {
  final String roomId;
  final Message message;

  const EditMessageParams({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, message];
}
