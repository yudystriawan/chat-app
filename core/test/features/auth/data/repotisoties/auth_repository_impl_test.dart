import 'package:core/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([AuthRemoteDataSource])
void main() {
  late AuthRepositoryImpl sut;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    sut = AuthRepositoryImpl(mockRemoteDataSource);
  });

  const userDto = UserDto(
    id: '123',
    username: 'john_doe',
    bio: 'A short bio',
    name: 'John Doe',
    email: 'john@example.com',
    photoUrl: 'https://example.com/photo.jpg',
    phoneNumber: '1234567890',
    contacts: ['contact1', 'contact2'],
  );

  group('loginWithGoogle', () {
    test('should return Right(unit) when login is successful', () async {
      // Arrange
      when(mockRemoteDataSource.loginWithGoogle())
          .thenAnswer((_) async => userDto);

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, right(unit));
    });

    test(
        'should return Left(Failure.canceledByUser()) when login is canceled by the user',
        () async {
      // Arrange
      when(mockRemoteDataSource.loginWithGoogle())
          .thenAnswer((_) async => null);

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, left(const Failure.canceledByUser()));
    });

    test(
        'should return Left(Failure.unexpectedError()) when an unexpected error occurs',
        () async {
      // Arrange
      when(mockRemoteDataSource.loginWithGoogle()).thenThrow(Exception());

      // Act
      final result = await sut.loginWithGoogle();

      // Assert
      expect(result, left(const Failure.unexpectedError()));
    });
  });

  group('signOut', () {
    test('should return Right(unit) when sign out is successful', () async {
      // Arrange
      when(mockRemoteDataSource.signOut()).thenAnswer((_) async {});

      // Act
      final result = await sut.signOut();

      // Assert
      expect(result, right(unit));
    });

    test(
        'should return Left(Failure.unexpectedError()) when an unexpected error occurs',
        () async {
      // Arrange
      when(mockRemoteDataSource.signOut()).thenThrow(Exception());

      // Act
      final result = await sut.signOut();

      // Assert
      expect(result, left(const Failure.unexpectedError()));
    });
  });

  group('watchCurrentUser', () {
    test('should return Right(User) when user is authenticated', () {
      // Arrange
      when(mockRemoteDataSource.watchCurrentUser())
          .thenAnswer((_) => Stream.value(userDto));

      // Act
      final result = sut.watchCurrentUser();

      // Assert
      expect(
        result,
        emitsInOrder(<dynamic>[
          right(userDto.toDomain()),
        ]),
      );
    });

    test(
        'should return Left(Failure.unauthenticated()) when user is unauthenticated',
        () {
      // Arrange
      when(mockRemoteDataSource.watchCurrentUser())
          .thenAnswer((_) => Stream.error(const Failure.unauthenticated()));

      // Act
      final result = sut.watchCurrentUser();

      // Assert
      expect(
        result,
        emitsInOrder(<dynamic>[
          left(const Failure.unauthenticated()),
        ]),
      );
    });

    test(
        'should return Left(Failure.unexpectedError()) when an unexpected error occurs',
        () {
      // Arrange
      when(mockRemoteDataSource.watchCurrentUser())
          .thenAnswer((_) => Stream.error(Exception()));

      // Act
      final result = sut.watchCurrentUser();

      // Assert
      expect(
        result,
        emitsInOrder(<dynamic>[
          left(const Failure.unexpectedError()),
        ]),
      );
    });
  });
}
