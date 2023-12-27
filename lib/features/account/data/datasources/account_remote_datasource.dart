import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/account_dtos.dart';

abstract class AccountRemoteDataSource {
  Future<void> saveAccount(AccountDto account);
  Stream<AccountDto?> watchCurrentAccount();
  Stream<List<AccountDto>?> watchAccounts({String? username});
  Future<void> updateOnlineStatus(bool status);
}

@Injectable(as: AccountRemoteDataSource)
class AccountFirebaseDataSourceImpl implements AccountRemoteDataSource {
  final FirestoreService _firestoreService;
  final AuthService _authService;

  AccountFirebaseDataSourceImpl(
    this._firestoreService,
    this._authService,
  );

  @override
  Future<void> saveAccount(AccountDto account) async {
    try {
      await _firestoreService.upsert('users', account.id, account.toJson());
    } on Failure {
      rethrow;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<AccountDto?> watchCurrentAccount() {
    return _authService
        .watchCurrentUser()
        .switchMap((user) => _firestoreService.watch('users', user?.uid))
        .map((json) => AccountDto.fromJson(json!));
  }

  @override
  Stream<List<AccountDto>?> watchAccounts({String? username}) {
    List<WhereCondition> conditions = [];
    if (username != null) {
      conditions.add(WhereCondition('username', isEqualTo: username));
    }

    return _firestoreService
        .watchAll('users', whereConditions: conditions)
        .map((docs) => docs.map((json) => AccountDto.fromJson(json)).toList())
        .onErrorReturnWith(
          (error, stackTrace) => throw const Failure.serverError(),
        );
  }

  @override
  Future<void> updateOnlineStatus(bool status) async {
    try {
      final request = {'isOnline': status};

      final currentUser = _authService.currentUser!;

      await _firestoreService.upsert('users', currentUser.uid, request);
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
