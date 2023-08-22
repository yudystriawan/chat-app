import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';

import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, Unit>> saveAccount(Account account);
  Stream<Either<Failure, Account>> watchAccount();
}
