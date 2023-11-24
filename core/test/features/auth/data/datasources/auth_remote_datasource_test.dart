import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([
  FirebaseAuth,
  GoogleSignIn,
  FirebaseFirestore,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  UserCredential,
  User,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
])
void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockFirebaseFirestore mockFirestore;
  late AuthFirebaseDataSource sut;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockFirestore = MockFirebaseFirestore();
    sut = AuthFirebaseDataSource(
      mockGoogleSignIn,
      mockFirebaseAuth,
      mockFirestore,
    );
  });

  final signInAccount = MockGoogleSignInAccount();
  final googleAuth = MockGoogleSignInAuthentication();

  final userCredential = MockUserCredential();
  final user = MockUser();
  final collectionReference = MockCollectionReference<Map<String, dynamic>>();
  final documentReference = MockDocumentReference<Map<String, dynamic>>();
  final documentSnaphot = MockDocumentSnapshot<Map<String, dynamic>>();

  void setupMockFirestore() {
    when(mockFirestore.collection(any)).thenReturn(collectionReference);
    when(collectionReference.doc(any)).thenReturn(documentReference);
    when(documentReference.snapshots())
        .thenAnswer((_) => Stream.value(documentSnaphot));
  }

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
          .thenReturn(AdditionalUserInfo(isNewUser: true));
      when(user.uid).thenReturn('123');
      when(user.email).thenReturn('example.com');
      when(user.displayName).thenReturn('John Doe');
      when(user.photoURL).thenReturn('https://example.com/photo.jpg');
      when(user.phoneNumber).thenReturn('1234567890');
      setupMockFirestore();

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNotNull);
      expect(result, isA<UserDto>());
      verify(mockGoogleSignIn.signIn()).called(1);
      verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
      verify(mockFirestore.collection('users')).called(1);
    });

    test('returns null when GoogleSignIn returns null', () async {
      // Arrange
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);
      setupMockFirestore();

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNull);
      verifyNever(mockFirebaseAuth.signInWithCredential(any));
      verifyNever(mockFirestore.collection('users'));
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
      setupMockFirestore();
      when(documentSnaphot.data()).thenReturn({
        'id': '123',
        'username': 'john_doe',
        'bio': 'A short bio',
        'name': 'John Doe',
        'email': 'john@example.com',
        'photoUrl': 'https://example.com/photo.jpg',
        'phoneNumber': '1234567890',
        'contacts': ['contact1', 'contact2'],
      });

      // Act
      final stream = sut.watchCurrentUser();

      // Assert
      expect(stream, emits(isA<UserDto>()));
    });

    test('watchCurrentUser throws Failure when user is unauthenticated', () {
      // Arrange
      when(mockFirebaseAuth.authStateChanges())
          .thenAnswer((_) => Stream.value(null));

      // Act
      final userStream = sut.watchCurrentUser();

      // Assert
      expect(
        userStream,
        emitsError(const TypeMatcher<Failure>()),
      );
    });
  });
}
