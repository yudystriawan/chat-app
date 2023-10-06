import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';
import '../reporitories/chat_repository.dart';

@injectable
class WatchMembers
    implements StreamUsecase<KtList<Member>, WatchMembersParams> {
  final ChatRepository _repository;

  WatchMembers(this._repository);

  @override
  Stream<Either<Failure, KtList<Member>>> call(params) async* {
    if (params.failure != null) yield* Stream.value(left(params.failure!));

    yield* _repository.watchMembers(params.ids);
  }
}

class WatchMembersParams extends Equatable {
  final KtList<String> ids;

  const WatchMembersParams({
    required this.ids,
  });

  Failure? get failure {
    if (ids.isEmpty()) {
      return const Failure.invalidParameter(message: 'ids cannot be empty.');
    }
    return null;
  }

  @override
  List<Object> get props => [ids];
}
