import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../repositories/account_repository.dart';

@injectable
class SetOnlineStatus implements Usecase<Unit, SetOnlineStatusParams> {
  final AccountRepository _repository;

  SetOnlineStatus(
    this._repository,
  );

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _repository.setOnlineStatus(params.onlineStatus);
  }
}

class SetOnlineStatusParams extends Equatable {
  final bool onlineStatus;

  const SetOnlineStatusParams({
    required this.onlineStatus,
  });

  @override
  List<Object> get props => [onlineStatus];
}
