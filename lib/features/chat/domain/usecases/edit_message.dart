import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';
import '../reporitories/chat_repository.dart';

@injectable
class EditMessage implements Usecase<Unit, EditMessageParams> {
  final ChatRepository _repository;

  EditMessage(this._repository);

  @override
  Future<Either<Failure, Unit>> call(params) async {
    if (params.failure != null) return left(params.failure!);

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

  Failure? get failure {
    if (roomId.isEmpty) {
      return const Failure.invalidParameter(
          message: 'Room Id cannot be empty.');
    }

    if (message == Message.empty()) {
      return const Failure.invalidParameter(message: 'Message is not valid.');
    }

    return null;
  }

  @override
  List<Object> get props => [roomId, message];
}
