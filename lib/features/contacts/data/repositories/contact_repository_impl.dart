import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/entities/contact.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_datasource.dart';

@Injectable(as: ContactRepository)
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _remoteDataSource;

  ContactRepositoryImpl(this._remoteDataSource);
  @override
  Stream<Either<Failure, KtList<Contact>>> getContacts({String? username}) {
    return _remoteDataSource.watchContacts(username: username).map(
      (contactsDto) {
        if (contactsDto == null || contactsDto.isEmpty) {
          return right<Failure, KtList<Contact>>(const KtList.empty());
        }

        final contacts = contactsDto.map((e) => e.toDomain()).toImmutableList();
        return right<Failure, KtList<Contact>>(contacts);
      },
    ).onErrorReturnWith(
      (error, stackTrace) => left<Failure, KtList<Contact>>(
        const Failure.unexpectedError(),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> addContact(String userId) async {
    try {
      await _remoteDataSource.addContact(userId);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Contact>> findContact(String username) async {
    try {
      final result = await _remoteDataSource.findContact(username);
      if (result == null) return left(const Failure.serverError());
      final contact = result.toDomain();
      return right(contact);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}
