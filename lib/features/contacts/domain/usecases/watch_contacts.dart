import 'package:chat_app/features/contacts/domain/repositories/contact_repostory.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../entities/contact.dart';

@injectable
class WatchContacts implements StreamUsecase<KtList<Contact>, NoParams> {
  final ContactRepository _repository;

  WatchContacts(this._repository);

  @override
  Stream<Either<Failure, KtList<Contact>>> call(NoParams params) {
    return _repository.getContacts();
  }
}
