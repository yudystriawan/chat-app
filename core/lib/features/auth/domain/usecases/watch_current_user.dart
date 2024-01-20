import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/errors/failure.dart';
import '../../../../utils/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class WatchCurrentUser implements StreamUsecase<User, NoParams> {
  final AuthRepository _repository;

  WatchCurrentUser(this._repository);

  @override
  Stream<Either<Failure, User>> call(NoParams params) {
    return _repository.watchCurrentUser();
  }
}
