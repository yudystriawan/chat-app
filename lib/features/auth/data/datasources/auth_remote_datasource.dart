import 'package:injectable/injectable.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase_services/auth_service.dart';
import '../models/model.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> loginWithGoogle();
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
}
