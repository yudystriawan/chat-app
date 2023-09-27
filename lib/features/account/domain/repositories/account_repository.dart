import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../entities/account.dart';

abstract class AccountRepository {
  Future<Either<Failure, Unit>> saveAccount(Account account);
  Stream<Either<Failure, Account>> watchAccount();
  Stream<Either<Failure, KtList<Account>>> watchAccounts({String? username});
  Future<Either<Failure, Unit>> setOnlineStatus(bool status);
}
