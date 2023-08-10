import 'package:dartz/dartz.dart';

import '../../../../utils/errors/failure.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> loginWithGoogle();
}
