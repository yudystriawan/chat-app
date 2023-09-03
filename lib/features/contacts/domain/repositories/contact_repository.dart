import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:kt_dart/collection.dart';

import '../entities/contact.dart';

abstract class ContactRepository {
  Stream<Either<Failure, KtList<Contact>>> getContacts({String? username});
  Future<Either<Failure, Unit>> addContact(String userId);
}
