import '../../../../core/errors/failure.dart';
import '../../../../core/services/firebase_services/auth_service.dart';
import '../models/model.dart';

abstract class AuthRemoteDatasource {
  Future<UserDto?> loginWithGoogle();
}

class AuthFirebaseDatasource implements AuthRemoteDatasource {
  final AuthService _service;

  AuthFirebaseDatasource(this._service);

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
