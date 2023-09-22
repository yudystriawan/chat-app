import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/features/auth/data/models/model.dart';
import 'package:core/services/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/contact_dtos.dart';

abstract class ContactRemoteDataSource {
  Stream<List<ContactDto>?> watchContacts({
    String? username,
  });
  Future<void> addContact(String userId);
  Future<ContactDto?> findContact(String username);
}

@Injectable(as: ContactRemoteDataSource)
class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final FirestoreService _service;

  ContactRemoteDataSourceImpl(this._service);

  @override
  Stream<List<ContactDto>?> watchContacts({String? username}) async* {
    final userRef = await _service.instance.userDocument();

    yield* userRef.snapshots().map((userDoc) {
      // get array userId in contacts
      final user = UserDto.fromFirestore(userDoc);
      final contacts = user.contacts;
      return contacts;
    }).switchMap((contacts) {
      // get the user data of contacts
      if (contacts == null || contacts.isEmpty) return Stream.value(null);

      final query =
          _service.instance.userCollection.where('id', whereIn: contacts);

      if (username != null) query.where('username', isEqualTo: username);

      return query.snapshots().map(
            (snap) => snap.docs
                .map(
                  (doc) =>
                      ContactDto.fromJson(doc.data() as Map<String, dynamic>),
                )
                .toList(),
          );
    }).onErrorReturnWith((error, stackTrace) {
      log('error occured', error: error, stackTrace: stackTrace);
      throw Failure.serverError(message: error.toString());
    });
  }

  @override
  Future<void> addContact(String userId) async {
    try {
      final userRef = await _service.instance.userDocument();

      final userDoc = await userRef.get();

      if (userDoc.exists) {
        var user = UserDto.fromFirestore(userDoc);

        final contacts = user.contacts ?? [];

        if (!contacts.contains(userId)) {
          // friend is not in contacts, add them
          contacts.add(userId);

          // Update the user's document with the new contacts array
          await userRef.update({'contacts': contacts});
        }
      }
    } catch (e) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<ContactDto?> findContact(String username) async {
    try {
      var querySnapshot = await _service.instance.userCollection
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      var contactDto = ContactDto.fromJson(
          querySnapshot.docs[0].data() as Map<String, dynamic>);
      return contactDto;
    } catch (e, s) {
      log('error occured', error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
