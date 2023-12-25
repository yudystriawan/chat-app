import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final GoogleSignIn _googleSignIn;
  final FirebaseAuth _firebaseAuth;

  AuthService(this._googleSignIn, this._firebaseAuth);

  Future<User?> loginWithGoogle() async {
    final signInAccount = await _googleSignIn.signIn();

    if (signInAccount == null) return null;

    final authentication = await signInAccount.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    return userCredential.user;
  }

  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
    return;
  }

  Stream<User?> watchCurrentUser() {
    return _firebaseAuth.authStateChanges();
  }

  User? get currentUser => _firebaseAuth.currentUser;
}
