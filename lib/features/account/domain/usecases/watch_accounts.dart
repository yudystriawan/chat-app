import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/account.dart';
import '../repositories/account_repository.dart';

@injectable
class WatchAccounts
    implements StreamUsecase<KtList<Account>, WatchAccountsParams> {
  final AccountRepository _repository;

  WatchAccounts(this._repository);

  @override
  Stream<Either<Failure, KtList<Account>>> call(WatchAccountsParams params) {
    return _repository.watchAccounts(username: params.username);
  }
}

class WatchAccountsParams extends Equatable {
  final String? username;

  const WatchAccountsParams({
    this.username,
  });

  @override
  List<Object?> get props => [username];
}
