import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class GetUnreadMessages
    implements StreamUsecase<KtList<Message>, GetUnreadMessagesParams> {
  final ChatRepository _repository;

  GetUnreadMessages(this._repository);

  @override
  Stream<Either<Failure, KtList<Message>>> call(
      GetUnreadMessagesParams params) {
    return _repository.getUnreadMessages(params.roomId);
  }
}

class GetUnreadMessagesParams extends Equatable {
  final String roomId;

  const GetUnreadMessagesParams({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}
