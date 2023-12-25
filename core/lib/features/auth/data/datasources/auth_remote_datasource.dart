import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utils/errors/failure.dart';
import '../models/user_dtos.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> loginWithGoogle();
  Future<void> signOut();
  Stream<UserDto?> watchCurrentUser();
}

@Injectable(as: AuthRemoteDataSource)
class AuthFirebaseDataSource implements AuthRemoteDataSource {
  final AuthService _service;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSource(
    this._service,
    this._firestore,
  );

  @override
  Future<UserDto?> loginWithGoogle() async {
    try {
      final user = await _service.loginWithGoogle();
      if (user == null) return null;

      var userDto = UserDto(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // store data new user
      final isExist =
          (await _firestore.collection('users').doc(userDto.id).get()).exists;

      if (!isExist) {
        await _firestore
            .collection('users')
            .doc(userDto.id)
            .set(userDto.toJson());
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
      await _service.signOut();
    } catch (e) {
      log('signOut error', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<UserDto?> watchCurrentUser() {
    return _service
        .watchCurrentUser()
        .switchMap((user) {
          if (user == null) throw const Failure.unauthenticated();
          return _firestore.collection('users').doc(user.uid).snapshots();
        })
        .map((doc) => UserDto.fromJson(doc.data() as Map<String, dynamic>))
        .onErrorReturnWith((error, stackTrace) =>
            throw Failure.serverError(message: error.toString()));
  }
}
