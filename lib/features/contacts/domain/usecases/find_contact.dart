import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import '../entities/contact.dart';
import '../repositories/contact_repository.dart';

@injectable
class FindContact implements Usecase<Contact, FindContactParams> {
  final ContactRepository _repository;

  FindContact(this._repository);

  @override
  Future<Either<Failure, Contact>> call(params) {
    return _repository.findContact(params.username);
  }
}

class FindContactParams extends Equatable {
  final String username;

  const FindContactParams({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}
