import '../repositories/contact_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddContact implements Usecase<Unit, AddContactParams> {
  final ContactRepository _repository;

  AddContact(this._repository);

  @override
  Future<Either<Failure, Unit>> call(params) {
    return _repository.addContact(params.username);
  }
}

class AddContactParams extends Equatable {
  final String username;

  const AddContactParams({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}
