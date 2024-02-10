import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:chat_app/features/account/domain/usecases/remove_account.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'remove_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late RemoveAccount sut;
  late MockAccountRepository mockRepository;

  setUpAll(() {
    mockRepository = MockAccountRepository();
    sut = RemoveAccount(mockRepository);
  });

  group('RemoveAccount', () {
    const accountId = 'user1';
    test('should remove an account and return unit', () async {
      // Arrange
      when(mockRepository.removeAccount(any))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(const RemoveAccountParams(accountId));

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.removeAccount(accountId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when remove an account fails', () async {
      // Arrange
      const failure = Failure.unexpectedError();
      when(mockRepository.removeAccount(any))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await sut(const RemoveAccountParams(accountId));

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.removeAccount(accountId)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
