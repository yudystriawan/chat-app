import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

abstract class AccountRemoteDataSource {
  Future<void> saveAccount(AccountDto account);
  Stream<AccountDto?> watchCurrentAccount();
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
}
