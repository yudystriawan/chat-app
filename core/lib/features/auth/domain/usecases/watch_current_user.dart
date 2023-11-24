import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class WatchCurretUser implements StreamUsecase<User, NoParams> {
  final AuthRepository _repository;

  WatchCurretUser(this._repository);

  @override
  Stream<Either<Failure, User>> call(NoParams params) {
    return _repository.watchCurrentUser();
  }
}
