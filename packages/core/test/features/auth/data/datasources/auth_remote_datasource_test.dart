import 'package:core/core.dart';
import 'package:core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  User,
])
void main() {
  late MockAuthService mockAuthService;
  late AuthFirebaseDataSource sut;

  final user = MockUser();

  setUp(() {
    mockAuthService = MockAuthService();

    sut = AuthFirebaseDataSource(mockAuthService);

    when(user.uid).thenReturn('123');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');
  });

  group('login with google', () {
    test('returns UserDto on successful login', () async {
      // Arrange
      when(mockAuthService.loginWithGoogle()).thenAnswer((_) async => user);

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

      // Act
      final userDto = await sut.loginWithGoogle();

      // Assert
      expect(userDto, isNull);
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
