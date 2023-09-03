import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSignedInUser implements Usecase<User, NoParams> {
  final AuthRepository _repository;

  GetSignedInUser(
    this._repository,
  );
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _repository.getSignedInUser();
  }
}
