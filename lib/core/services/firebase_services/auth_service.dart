import 'package:chat_app/core/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<User?> loginWithGoogle();
  Future<void> signOut();
  Stream<User?> listenUserChanges();
}

class AuthFirebaseServiceImpl implements AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthFirebaseServiceImpl(this._googleSignIn, this._firebaseAuth);

  @override
  Future<User?> loginWithGoogle() async {
    try {
      final signInAccount = await _googleSignIn.signIn();

      if (signInAccount != null) {
        final googleAuth = await signInAccount.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
          accessToken: googleAuth.accessToken,
        );

        final userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        return userCredential.user;
      }

      return null;
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
