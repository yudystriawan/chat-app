import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/account.dart';

@injectable
class WatchAccount implements StreamUsecase<Account, NoParams> {
  final AccountRepository _repository;

  WatchAccount(this._repository);
  @override
  Stream<Either<Failure, Account>> call(NoParams params) {
    return _repository.watchAccount();
  }
}
