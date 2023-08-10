import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../errors/failure.dart';

abstract class AuthService {
  Future<User?> loginWithGoogle();
  Future<void> signOut();
  Stream<User?> listenUserChanges();
}

@Injectable(as: AuthService)
class AuthFirebaseServiceImpl implements AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseServiceImpl(this._googleSignIn, this._firebaseAuth);

  @override
  Future<User?> loginWithGoogle() async {
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

      return userCredential.user;
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
  Stream<User?> listenUserChanges() {
    try {
      return _firebaseAuth.authStateChanges();
    } catch (e) {
      throw const Failure.unexpectedError();
    }
  }
}
