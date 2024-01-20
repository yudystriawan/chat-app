import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:chat_app/features/account/domain/usecases/save_account.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'save_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late SaveAccount sut;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    sut = SaveAccount(mockRepository);
  });

  group('SaveAccount', () {
    // Define a sample account for testing
    const testAccount = Account(
      id: '1',
      username: 'test_user',
      bio: 'Test bio',
      name: 'Test User',
      email: 'test@example.com',
      photoUrl: 'https://example.com/test_photo.jpg',
      phoneNumber: '+1234567890',
      contacts: KtList.empty(),
    );

    test('should save an account and return Unit', () async {
      // Arrange
      when(mockRepository.saveAccount(any))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await sut(const SaveAccountParams(account: testAccount));

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.saveAccount(testAccount));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when saving an account fails', () async {
      // Arrange
      const failure = Failure.unexpectedError();
      when(mockRepository.saveAccount(any))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await sut(const SaveAccountParams(account: testAccount));

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.saveAccount(testAccount));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
