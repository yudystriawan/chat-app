import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class GetMessages implements StreamUsecase<KtList<Message>, GetMessagesParams> {
  final ChatRepository _repository;

  GetMessages(this._repository);

  @override
  Stream<Either<Failure, KtList<Message>>> call(params) {
    return _repository.getMessages(
      params.roomId,
      limit: params.limit,
    );
  }
}

class GetMessagesParams extends Equatable {
  final String roomId;
  final int limit;

  const GetMessagesParams({
    required this.roomId,
    required this.limit,
  });

  @override
  List<Object> get props => [roomId];
}
