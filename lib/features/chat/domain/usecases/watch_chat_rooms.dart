import '../reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class WatchChatRooms implements StreamUsecase<KtList<Room>, NoParams> {
  final ChatRepository _chatRepository;

  WatchChatRooms(this._chatRepository);

  @override
  Stream<Either<Failure, KtList<Room>>> call(NoParams params) {
    return _chatRepository.watchChatRooms();
  }
}
