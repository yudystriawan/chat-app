import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/entity.dart';

@injectable
class GetMembers implements StreamUsecase<KtList<Member>, GetMembersParams> {
  final ChatRepository _repository;

  GetMembers(this._repository);

  @override
  Stream<Either<Failure, KtList<Member>>> call(params) {
    return _repository.getMembers(params.ids);
  }
}

class GetMembersParams extends Equatable {
  final KtList<String> ids;

  const GetMembersParams({
    required this.ids,
  });

  @override
  List<Object> get props => [ids];
}
