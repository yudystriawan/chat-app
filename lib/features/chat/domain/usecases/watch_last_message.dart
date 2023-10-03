import '../reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/entity.dart';

@injectable
class WatchLastMessage
    implements StreamUsecase<Message, WatchLastMessageParams> {
  final ChatRepository _repository;

  WatchLastMessage(this._repository);

  @override
  Stream<Either<Failure, Message>> call(params) {
    return _repository.watchLastMessage(params.roomId);
  }
}

class WatchLastMessageParams extends Equatable {
  final String roomId;

  const WatchLastMessageParams(this.roomId);

  @override
  List<Object> get props => [roomId];
}
