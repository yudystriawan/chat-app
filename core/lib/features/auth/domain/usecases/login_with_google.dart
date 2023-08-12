import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/errors/failure.dart';
import '../../../../utils/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginWithGoogle implements Usecase<Unit, NoParams> {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _repository.loginWithGoogle();
  }
}
