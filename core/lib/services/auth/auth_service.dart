import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final GoogleSignIn _googleSignIn;
  final fb.FirebaseAuth _firebaseAuth;

  AuthService(this._googleSignIn, this._firebaseAuth);

  Future<User?> loginWithGoogle() async {
    final signInAccount = await _googleSignIn.signIn();

    if (signInAccount == null) return null;

    final authentication = await signInAccount.authentication;

    final credential = fb.GoogleAuthProvider.credential(
      idToken: authentication.idToken,
      accessToken: authentication.accessToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    return User.fromFirebase(userCredential.user);
  }

  Future<void> signOut() async {
    await Future.wait([
      _googleSignIn.signOut(),
      _firebaseAuth.signOut(),
    ]);
    return;
  }

  Stream<User?> watchCurrentUser() {
    return _firebaseAuth
        .authStateChanges()
        .map((user) => User.fromFirebase(user));
  }

  void useEmulator(String host, int port) =>
      _firebaseAuth.useAuthEmulator(host, port);

  User? get currentUser => User.fromFirebase(_firebaseAuth.currentUser);
}

class User {
  fb.User? _user;

  User.fromFirebase(fb.User? user) {
    _user = user;
  }

  String? get uid => _user?.uid;
  String? get displayName => _user?.displayName;
  String? get email => _user?.email;
  String? get phoneNumber => _user?.phoneNumber;
  String? get photoURL => _user?.photoURL;
}
