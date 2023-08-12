import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateMessage implements Usecase<Unit, CreateMessageParams> {
  final ChatRepository _repostory;

  CreateMessage(this._repostory);

  @override
  Future<Either<Failure, Unit>> call(CreateMessageParams params) async {
    return await _repostory.createMessage(
      roomId: params.roomId,
      message: params.message,
    );
  }
}

class CreateMessageParams extends Equatable {
  final String roomId;
  final String message;

  const CreateMessageParams({
    required this.roomId,
    required this.message,
  });

  @override
  List<Object> get props => [roomId, message];
}
