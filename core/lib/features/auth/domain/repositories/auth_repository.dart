import 'package:dartz/dartz.dart';

import '../../../../utils/errors/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, Unit>> loginWithGoogle();
  Future<Either<Failure, Unit>> signOut();
  Stream<Either<Failure, User>> watchUser();
  Future<Either<Failure, User>> getSignedInUser();
}
