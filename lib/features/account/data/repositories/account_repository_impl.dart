import 'package:chat_app/features/account/data/datasources/account_remote_datasource.dart';
import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

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
}
