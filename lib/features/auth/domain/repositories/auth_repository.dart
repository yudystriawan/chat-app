import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> loginWithGoogle();
}
