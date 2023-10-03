import '../repositories/contact_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/contact.dart';

@injectable
class WatchContacts
    implements StreamUsecase<KtList<Contact>, WatchContactsParams> {
  final ContactRepository _repository;

  WatchContacts(this._repository);

  @override
  Stream<Either<Failure, KtList<Contact>>> call(WatchContactsParams params) {
    return _repository.getContacts();
  }
}

class WatchContactsParams extends Equatable {
  final String? username;

  const WatchContactsParams({this.username});

  @override
  List<Object?> get props => [username];
}
