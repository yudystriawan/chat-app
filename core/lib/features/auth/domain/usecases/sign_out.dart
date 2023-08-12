import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class SignOut implements Usecase<Unit, NoParams> {
  final AuthRepository _repository;

  SignOut(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _repository.signOut();
  }
}
