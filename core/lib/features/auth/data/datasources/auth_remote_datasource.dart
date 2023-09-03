import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utils/errors/failure.dart';
import '../models/model.dart';

abstract class AuthRemoteDataSource {
  Future<UserDto?> loginWithGoogle();
  Future<void> signOut();
  Stream<UserDto?> watchUser();
  Future<UserDto?> getCurrentUser();
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

      // store data new user
      if ((userCredential.additionalUserInfo?.isNewUser ?? false)) {
        await _firestore.collection('users').doc(user.uid).set(
              UserDto.fromFirebaseAuth(user).toJson(),
            );
      }

      return UserDto.fromFirebaseAuth(user);
    } catch (e) {
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
      throw const Failure.unexpectedError();
    }
  }

  @override
  Stream<UserDto?> watchUser() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) throw const Failure.unauthenticated();
      return UserDto.fromFirebaseAuth(user);
    }).onErrorReturnWith(
      (error, stackTrace) => throw Failure.serverError(
        message: error.toString(),
      ),
    );
  }

  @override
  Future<UserDto?> getCurrentUser() async {
    try {
      final userDoc = await _firestore.userDocument();
      final userData = await userDoc.get();

      return UserDto.fromFirestore(userData);
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}
