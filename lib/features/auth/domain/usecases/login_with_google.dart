import 'package:chat_app/core/errors/failure.dart';
import 'package:chat_app/core/usecases/usecase.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../entities/user.dart';

class LoginWithGoogle implements Usecase<User, NoParams> {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await _repository.loginWithGoogle();
  }
}
