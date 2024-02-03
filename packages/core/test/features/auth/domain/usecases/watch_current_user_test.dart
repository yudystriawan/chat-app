import 'package:core/features/auth/domain/entities/user.dart';
import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/features/auth/domain/usecases/watch_current_user.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_current_user_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('WatchCurrentUser', () {
    late WatchCurrentUser sut;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      sut = WatchCurrentUser(mockRepository);
    });

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

    test('should return a stream of User from the repository', () {
      // Arrange
      when(mockRepository.watchCurrentUser())
          .thenAnswer((_) => Stream.value(Right(user)));

      // Act
      final result = sut(const NoParams());

      // Assert
      expect(result, emits(Right(user)));
      verify(mockRepository.watchCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a stream of Failure from the repository on error', () {
      // Arrange
      const failure = Failure.serverError(message: 'Something went wrong');
      when(mockRepository.watchCurrentUser())
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result = sut(const NoParams());

      // Assert
      expect(result, emits(const Left(failure)));
      verify(mockRepository.watchCurrentUser()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
