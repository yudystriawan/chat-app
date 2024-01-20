import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/errors/failure.dart';
import '../../../../utils/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginWithGoogle implements Usecase<User, NoParams> {
  final AuthRepository _repository;

  LoginWithGoogle(this._repository);
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    // lateEither<Failure, User> failureOrUser;
    final failureOrSuccess = await _repository.loginWithGoogle();
    return await failureOrSuccess.fold(
      (f) async => left(f),
      (_) async => await _repository.watchCurrentUser().first,
    );
  }
}
