import 'package:chat_app/features/contacts/data/datasources/contact_remote_datasource.dart';
import 'package:chat_app/features/contacts/domain/entities/contact.dart';
import 'package:chat_app/features/contacts/domain/repositories/contact_repostory.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';
import 'package:rxdart/rxdart.dart';

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
}
