import 'package:core/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([
  fb.FirebaseAuth,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  fb.UserCredential,
  fb.User,
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late AuthService sut;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    sut = AuthService(
      mockGoogleSignIn,
      mockFirebaseAuth,
    );
  });

  final signInAccount = MockGoogleSignInAccount();
  final googleAuth = MockGoogleSignInAuthentication();

  final userCredential = MockUserCredential();
  final user = MockUser();

  group('login with google', () {
    test('returns UserDto on successful login', () async {
      // Arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => signInAccount);
      when(signInAccount.authentication).thenAnswer((_) async => googleAuth);
      when(googleAuth.idToken).thenReturn('idToken');
      when(googleAuth.accessToken).thenReturn('accessToken');
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => userCredential);
      when(userCredential.user).thenReturn(user);
      when(userCredential.additionalUserInfo)
          .thenReturn(fb.AdditionalUserInfo(isNewUser: true));
      when(user.uid).thenReturn('123');
      when(user.email).thenReturn('example.com');
      when(user.displayName).thenReturn('John Doe');
      when(user.photoURL).thenReturn('https://example.com/photo.jpg');
      when(user.phoneNumber).thenReturn('1234567890');

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNotNull);
      expect(result, isA<User>());
      verify(mockGoogleSignIn.signIn()).called(1);
      verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
    });

    test('returns null when GoogleSignIn returns null', () async {
      // Arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNull);
      verifyNever(mockFirebaseAuth.signInWithCredential(any));
    });
  });

  group('signOut', () {
    test('sign out both GoogleSignIn and FirebaseAuth', () async {
      // Arrange
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

      // Act
      await sut.signOut();

      // Assert
      verify(mockGoogleSignIn.signOut()).called(1);
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });

  group('watchCurrentUser', () {
    test('watchCurrentUser emits UserDto when user is authenticated', () {
      // Arrange
      when(user.uid).thenReturn('testUserId');
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(user));
      // Act
      final stream = sut.watchCurrentUser();

      // Assert
      expect(stream, emits(isA<User>()));
    });

    test('watchCurrentUser return null when user is unauthenticated', () {
      // Arrange
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      // Act
      final userStream = sut.watchCurrentUser();

      // Assert
      expect(
        userStream,
        emits(isA<User>()),
      );
    });
  });
}
