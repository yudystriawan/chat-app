import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  DocumentSnapshot,
  User,
])
void main() {
  late MockAuthService mockAuthService;
  late MockFirebaseFirestore mockFirestore;
  late AuthFirebaseDataSource sut;

  setUp(() {
    mockAuthService = MockAuthService();
    mockFirestore = MockFirebaseFirestore();
    sut = AuthFirebaseDataSource(
      mockAuthService,
      mockFirestore,
    );
  });

  final collectionReference = MockCollectionReference<Map<String, dynamic>>();
  final documentReference = MockDocumentReference<Map<String, dynamic>>();
  final documentSnaphot = MockDocumentSnapshot<Map<String, dynamic>>();
  final user = MockUser();

  void setupMockFirestore() {
    when(mockFirestore.collection(any)).thenReturn(collectionReference);
    when(collectionReference.doc(any)).thenReturn(documentReference);
    when(documentReference.get()).thenAnswer((_) async => documentSnaphot);
    when(documentReference.snapshots())
        .thenAnswer((_) => Stream.value(documentSnaphot));
    when(user.uid).thenReturn('123');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');
  }

  group('login with google', () {
    test('returns UserDto on successful login', () async {
      // Arrange
      setupMockFirestore();
      when(mockAuthService.loginWithGoogle()).thenAnswer((_) async => user);
      when(documentSnaphot.exists).thenAnswer((_) => false);

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNotNull);
      expect(result, isA<UserDto>());
      verify(mockAuthService.loginWithGoogle()).called(1);
    });

    test('returns null when GoogleSignIn returns null', () async {
      // Arrange
      when(mockAuthService.loginWithGoogle()).thenAnswer((_) async => null);
      setupMockFirestore();

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, isNull);
      verifyNever(mockFirestore.collection('users'));
    });
  });

  group('signOut', () {
    test('sign out both GoogleSignIn and FirebaseAuth', () async {
      // Arrange
      when(mockAuthService.signOut()).thenAnswer((_) async {});

      // Act
      await sut.signOut();

      // Assert
      verify(mockAuthService.signOut()).called(1);
    });
  });

  group('watchCurrentUser', () {
    test('watchCurrentUser emits UserDto when user is authenticated', () {
      // Arrange
      when(mockAuthService.watchCurrentUser())
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
      when(mockAuthService.watchCurrentUser())
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
