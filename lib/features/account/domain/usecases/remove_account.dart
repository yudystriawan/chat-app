import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class RemoveAccount extends Usecase<Unit, RemoveAccountParams> {
  final AccountRepository _repository;

  RemoveAccount(this._repository);

  @override
  Future<Either<Failure, Unit>> call(params) async {
    return await _repository.removeAccount(params.id);
  }
}

class RemoveAccountParams extends Equatable {
  final String id;

  const RemoveAccountParams(this.id);

  @override
  List<Object> get props => [id];
}
