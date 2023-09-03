import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class SaveAccount implements Usecase<Unit, SaveAccountParams> {
  final AccountRepository _repository;

  SaveAccount(this._repository);
  @override
  Future<Either<Failure, Unit>> call(params) async {
    return await _repository.saveAccount(params.account);
  }
}

class SaveAccountParams extends Equatable {
  final Account account;

  const SaveAccountParams({
    required this.account,
  });

  @override
  List<Object> get props => [account];
}
