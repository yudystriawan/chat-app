import 'package:chat_app/core/services/firebase_services/auth_service.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService sut;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth(
      mockUser: MockUser(
        isAnonymous: false,
        email: 'test@example.com',
        displayName: 'test user',
      ),
    );
    mockGoogleSignIn = MockGoogleSignIn();
    sut = AuthFirebaseServiceImpl(mockGoogleSignIn, mockFirebaseAuth);
  });

  group('loginWithGoogle', () {
    test('should return user', () async {
      final user = await sut.loginWithGoogle();
      expect(user, isNotNull);
    });

    test('should return null when user canceled', () async {
      mockGoogleSignIn.setIsCancelled(true);

      final user = await sut.loginWithGoogle();

      expect(user, isNull);
    });
  });

  group('signOut', () {
    // test('should signout from google and firebase', () async {
    //   // emulate google sign already login
    //   await mockGoogleSignIn.signIn();

    //   await sut.signOut();

    //   expect(mockFirebaseAuth.currentUser, isNull);
    //   expect(mockGoogleSignIn.currentUser, isNull);
    // });
  });

  group('listenUserChanges', () {});
}
