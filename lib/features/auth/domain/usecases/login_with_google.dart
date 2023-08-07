import 'package:chat_app/core/errors/failure.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class LoginWithGoogle implements Usecase<Unit, NoParams> {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);
  @override
  Future<Either<Failure, Unit>> call(NoParams params) async {
    return await _repository.loginWithGoogle();
  }
}
