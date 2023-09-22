import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class WatchUnreadMessages
    implements StreamUsecase<KtList<Message>, WatchUnreadMessagesParams> {
  final ChatRepository _repository;

  WatchUnreadMessages(this._repository);

  @override
  Stream<Either<Failure, KtList<Message>>> call(
      WatchUnreadMessagesParams params) {
    return _repository.watchUnreadMessages(params.roomId);
  }
}

class WatchUnreadMessagesParams extends Equatable {
  final String roomId;

  const WatchUnreadMessagesParams({
    required this.roomId,
  });

  @override
  List<Object> get props => [roomId];
}
