import 'dart:developer';

import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:core/core.dart';
import 'package:core/services/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

abstract class AccountRemoteDataSource {
  Future<void> saveAccount(AccountDto account);
  Stream<AccountDto?> watchCurrentAccount();
  Stream<List<AccountDto>?> watchAccounts({String? username});
  Future<void> updateOnlineStatus(bool status);
}

@Injectable(as: AccountRemoteDataSource)
class AccountFirebaseDataSourceImpl implements AccountRemoteDataSource {
  final FirestoreService _service;

  AccountFirebaseDataSourceImpl(this._service);

  @override
  Future<void> saveAccount(AccountDto account) async {
    try {
      final userDoc = await _service.instance.userDocument();
      userDoc.update(account.toJson());
    } on Failure {
      rethrow;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<AccountDto?> watchCurrentAccount() async* {
    final userDoc = await _service.instance.userDocument();
    yield* userDoc.snapshots().map((snapshot) => AccountDto.fromJson(
          snapshot.data() as Map<String, dynamic>,
        ));
  }

  @override
  Stream<List<AccountDto>?> watchAccounts({String? username}) {
    final query = _service.instance.userCollection;

    if (username != null) {
      query.where('username', isEqualTo: username);
    }

    return query
        .snapshots()
        .map((snaps) => snaps.docs
            .map((doc) => AccountDto.fromJson(doc as Map<String, dynamic>))
            .toList())
        .onErrorReturnWith(
          (error, stackTrace) => throw const Failure.serverError(),
        );
  }

  @override
  Future<void> updateOnlineStatus(bool status) async {
    try {
      final userDoc = await _service.instance.userDocument();

      final request = {'isOnline': status};

      await _service.instance.userCollection.doc(userDoc.id).update(request);
    } catch (e, s) {
      log(
        'an error occured',
        name: 'updateOnlineStatus',
        error: e,
        stackTrace: s,
      );
      throw const Failure.serverError();
    }
  }
}
