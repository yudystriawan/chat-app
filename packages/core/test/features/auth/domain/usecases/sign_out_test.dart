import 'package:core/features/auth/domain/repositories/auth_repository.dart';
import 'package:core/features/auth/domain/usecases/sign_out.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'sign_out_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  group('SignOut', () {
    late SignOut sut;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      sut = SignOut(mockRepository);
    });

    test('should return unit from repository on successful sign-out', () async {
      // Arrange
      when(mockRepository.signOut()).thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.signOut());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return an error from repository on sign-out failure',
        () async {
      // Arrange
      const mockFailure = Failure.unexpectedError();
      when(mockRepository.signOut())
          .thenAnswer((_) async => const Left(mockFailure));

      // Act
      final result = await sut(const NoParams());

      // Assert
      expect(result, const Left(mockFailure));
      verify(mockRepository.signOut());
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
