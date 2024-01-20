import 'dart:async';

import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:chat_app/features/account/domain/usecases/watch_accounts.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_accounts_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late WatchAccounts sut;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    sut = WatchAccounts(mockRepository);
  });

  group('WatchAccounts', () {
    // Define a sample list of accounts for testing
    final testAccounts = KtList.of(
      const Account(
        id: '1',
        username: 'test_user_1',
        bio: 'Test bio 1',
        name: 'Test User 1',
        email: 'test1@example.com',
        photoUrl: 'https://example.com/test_photo_1.jpg',
        phoneNumber: '+1234567890',
        contacts: KtList.empty(),
      ),
      const Account(
        id: '2',
        username: 'test_user_2',
        bio: 'Test bio 2',
        name: 'Test User 2',
        email: 'test2@example.com',
        photoUrl: 'https://example.com/test_photo_2.jpg',
        phoneNumber: '+9876543210',
        contacts: KtList.empty(),
      ),
    );

    test(
        'should emit a list of accounts when the repository stream emits accounts',
        () {
      // Arrange
      when(mockRepository.watchAccounts(username: anyNamed('username')))
          .thenAnswer((_) => Stream.value(Right(testAccounts)));

      // Act
      final result =
          sut(const WatchAccountsParams(username: 'test_user')).take(1);

      // Assert
      expectLater(result, emits(Right(testAccounts)));
    });

    test('should emit a failure when the repository stream emits a failure',
        () {
      // Arrange
      const failure = Failure.unexpectedError();
      when(mockRepository.watchAccounts(username: anyNamed('username')))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result =
          sut(const WatchAccountsParams(username: 'test_user')).take(1);

      // Assert
      expectLater(result, emits(const Left(failure)));
    });
  });
}
