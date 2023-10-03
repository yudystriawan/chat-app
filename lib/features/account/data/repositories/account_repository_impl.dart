import 'dart:developer';

import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/account.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_remote_datasource.dart';
import '../models/account_dtos.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource _remoteDataSource;

  AccountRepositoryImpl(
    this._remoteDataSource,
  );
  @override
  Future<Either<Failure, Unit>> saveAccount(Account account) async {
    try {
      await _remoteDataSource.saveAccount(AccountDto.fromDomain(account));
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<Either<Failure, Account>> watchAccount() {
    return _remoteDataSource.watchCurrentAccount().map((accountDto) {
      if (accountDto == null) {
        return left<Failure, Account>(const Failure.serverError());
      }

      return right<Failure, Account>(accountDto.toDomain());
    });
  }

  @override
  Stream<Either<Failure, KtList<Account>>> watchAccounts({String? username}) {
    return _remoteDataSource.watchAccounts(username: username).map((accounts) {
      if (accounts == null) {
        return right<Failure, KtList<Account>>(const KtList.empty());
      }

      final domain = accounts.map((e) => e.toDomain()).toImmutableList();
      return right<Failure, KtList<Account>>(domain);
    }).onErrorReturnWith((error, stackTrace) {
      if (error is Failure) {
        return left<Failure, KtList<Account>>(error);
      }

      return left<Failure, KtList<Account>>(const Failure.serverError());
    });
  }

  @override
  Future<Either<Failure, Unit>> setOnlineStatus(bool status) async {
    try {
      await _remoteDataSource.updateOnlineStatus(status);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e, s) {
      log(
        'an error occured',
        name: 'setOnlineStatus',
        error: e,
        stackTrace: s,
      );
      return left(const Failure.unexpectedError());
    }
  }
}
