import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthFirebaseDataSource(
    this._googleSignIn,
    this._firebaseAuth,
    this._firestore,
  );

  @override
  Future<UserDto?> loginWithGoogle() async {
    try {
      final signInAccount = await _googleSignIn.signIn();

      if (signInAccount == null) return null;

      final googleAuth = await signInAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) return null;

      var userDto = UserDto(
        id: user.uid,
        email: user.email,
        name: user.displayName,
        photoUrl: user.photoURL,
        phoneNumber: user.phoneNumber,
      );

      // store data new user
      if ((userCredential.additionalUserInfo?.isNewUser ?? false)) {
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
      await Future.wait([
        _googleSignIn.signOut(),
        _firebaseAuth.signOut(),
      ]);
    } catch (e) {
      log('signOut error', error: e);
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<UserDto?> watchCurrentUser() {
    return _firebaseAuth
        .authStateChanges()
        .switchMap((user) {
          if (user == null) throw const Failure.unauthenticated();
          return _firestore.collection('users').doc(user.uid).snapshots();
        })
        .map((doc) => UserDto.fromJson(doc.data() as Map<String, dynamic>))
        .onErrorReturnWith((error, stackTrace) =>
            throw Failure.serverError(message: error.toString()));
  }
}
