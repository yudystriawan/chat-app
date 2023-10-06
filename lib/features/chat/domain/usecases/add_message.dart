import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';
import '../reporitories/chat_repository.dart';

@injectable
class AddMessage implements Usecase<Message, AddMessageParams> {
  final ChatRepository _repostory;

  AddMessage(this._repostory);

  @override
  Future<Either<Failure, Message>> call(AddMessageParams params) async {
    if (params.failure != null) return left(params.failure!);

    return await _repostory.addMessage(
      roomId: params.roomId,
      message: params.message,
      type: params.type,
      replyMessage: params.replyMessage,
    );
  }
}

class AddMessageParams extends Equatable {
  final String roomId;
  final String message;
  final MessageType type;
  final Message? replyMessage;

  const AddMessageParams({
    required this.roomId,
    required this.message,
    required this.type,
    this.replyMessage,
  });

  Failure? get failure {
    if (roomId.isEmpty) {
      return const Failure.invalidParameter(message: 'RoomId must not empty');
    }
    return null;
  }

  @override
  List<Object> get props => [roomId, message, type];
}
