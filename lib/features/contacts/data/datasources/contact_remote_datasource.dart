import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/services/auth/auth_service.dart';
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
  final AuthService _authService;

  ContactRemoteDataSourceImpl(
    this._service,
    this._authService,
  );

  @override
  Stream<List<ContactDto>?> watchContacts({String? username}) {
    final userId = _authService.currentUser!.uid;

    return _service
        .watch('users', userId)
        .map((json) => UserDto.fromJson(json!))
        .map((userDto) => userDto.contacts)
        .switchMap<List<ContactDto>>((contacts) {
      if (contacts == null || contacts.isEmpty) return Stream.value([]);

      return _service.watchAll('users', whereConditions: [
        WhereCondition('id', whereIn: contacts)
      ]).map((docs) => docs.map((e) => ContactDto.fromJson(e)).toList());
    }).onErrorReturnWith((error, stackTrace) {
      log('error occured', error: error, stackTrace: stackTrace);
      throw Failure.serverError(message: error.toString());
    });
  }

  @override
  Future<void> addContact(String userId) async {
    try {
      final currentUserId = _authService.currentUser!.uid;
      return _service.upsert('users', currentUserId, {
        'contacts': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<ContactDto?> findContact(String username) async {
    try {
      return _service
          .watchAll('users', whereConditions: [
            WhereCondition('username', isEqualTo: username)
          ])
          .map((docs) => docs.map((e) => ContactDto.fromJson(e)).toList().first)
          .first;
    } catch (e, s) {
      log('error occured', error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
