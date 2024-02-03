import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/features/auth/domain/usecases/login_with_google.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'login_with_google_test.mocks.dart'; // Update the import path based on your project structure

@GenerateMocks([AuthRepository])
void main() {
  group('LoginWithGoogle', () {
    late LoginWithGoogle sut;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      sut = LoginWithGoogle(mockRepository);
    });

    test('should return user from repository on successful login', () async {
      // Arrange
      final user = User(
        id: '1',
        username: 'john_doe',
        bio: 'Software Developer',
        name: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: KtList.from(['friend1', 'friend2']),
      );
      when(mockRepository.loginWithGoogle())
          .thenAnswer((_) async => const Right(unit));
      when(mockRepository.watchCurrentUser())
          .thenAnswer((_) => Stream.value(right(user)));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, Right(user));
      verify(mockRepository.loginWithGoogle()).called(1);
      verify(mockRepository.watchCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return an error from repository on login failure', () async {
      // Arrange
      const mockFailure = Failure.unexpectedError();
      when(mockRepository.loginWithGoogle())
          .thenAnswer((_) async => const Left(mockFailure));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Left(mockFailure));
      verify(mockRepository.loginWithGoogle()).called(1);
      verifyNever(mockRepository.watchCurrentUser());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
