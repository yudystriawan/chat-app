import 'dart:async';

import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:chat_app/features/account/domain/usecases/watch_account.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_account_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late WatchAccount sut;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    sut = WatchAccount(mockRepository);
  });

  group('WatchAccount', () {
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

    test('should emit account when the repository stream emits an account', () {
      // Arrange
      when(mockRepository.watchAccount())
          .thenAnswer((_) => Stream.value(const Right(testAccount)));

      // Act
      final result = sut(const NoParams()).take(1);

      // Assert
      expectLater(result, emits(const Right(testAccount)));
    });

    test('should emit failure when the repository stream emits a failure', () {
      // Arrange
      const failure = Failure.unexpectedError();
      when(mockRepository.watchAccount())
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result = sut(const NoParams()).take(1);

      // Assert
      expectLater(result, emits(const Left(failure)));
    });
  });
}
