import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utils/errors/failure.dart';
import '../models/model.dart';
import 'firebase/auth_service.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> loginWithGoogle();
  Future<void> signOut();
  Stream<UserDto?> watchUser();
}

@Injectable(as: AuthRemoteDataSource)
class AuthFirebaseDataSource implements AuthRemoteDataSource {
  final AuthService _service;

  AuthFirebaseDataSource(this._service);

  @override
  Future<UserDto?> loginWithGoogle() async {
    try {
      final user = await _service.loginWithGoogle();

      if (user == null) return null;

      return UserDto.fromFirebase(user);
    } on Failure {
      rethrow;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _service.signOut();
      return;
    } on Failure {
      rethrow;
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<UserDto?> watchUser() {
    return _service.listenUserChanges().map((user) {
      if (user == null) return null;
      return UserDto.fromFirebase(user);
    }).onErrorReturnWith(
      (error, stackTrace) => throw Failure.serverError(
        message: error.toString(),
      ),
    );
  }
}
