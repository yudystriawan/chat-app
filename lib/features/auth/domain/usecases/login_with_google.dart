import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class LoginWithGoogle implements Usecase<Unit, NoParams> {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _repository.loginWithGoogle();
  }
}
