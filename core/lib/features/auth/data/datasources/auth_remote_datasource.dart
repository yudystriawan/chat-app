import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../core.dart';
import '../../../../services/auth/auth_service.dart';
import '../models/user_dtos.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> loginWithGoogle();
  Future<void> signOut();
  Stream<UserDto?> watchCurrentUser();
}

@Injectable(as: AuthRemoteDataSource)
class AuthFirebaseDataSource implements AuthRemoteDataSource {
  final AuthService _authService;
  final FirestoreService _firestoreService;

  AuthFirebaseDataSource(
    this._authService,
    this._firestoreService,
  );

  @override
  Future<UserDto?> loginWithGoogle() async {
    try {
      final user = await _authService.loginWithGoogle();
      if (user == null) return null;

      var userDto = UserDto(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // store data new user when is not exist
      final isExist = await _firestoreService.checkIfExist('users', userDto.id);

      if (!isExist) {
        await _firestoreService.upsert('users', userDto.id, userDto.toJson());
      }

      return userDto;
    } catch (e) {
      log('loginWithGoogle error', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authService.signOut();
    } catch (e) {
      log('signOut error', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<UserDto?> watchCurrentUser() {
    return _authService
        .watchCurrentUser()
        .switchMap((user) {
          if (user == null) throw const Failure.unauthenticated();
          return _firestoreService.watch('users', user.uid);
        })
        .map((json) => UserDto.fromJson(json!))
        .onErrorReturnWith((error, stackTrace) =>
            throw Failure.serverError(message: error.toString()));
  }
}
