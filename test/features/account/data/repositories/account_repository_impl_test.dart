import 'package:chat_app/features/account/data/datasources/account_remote_datasource.dart';
import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:chat_app/features/account/data/repositories/account_repository_impl.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_repository_impl_test.mocks.dart';

@GenerateMocks([AccountRemoteDataSource])
void main() {
  late AccountRepositoryImpl sut;
  late MockAccountRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    mockRemoteDataSource = MockAccountRemoteDataSource();
    sut = AccountRepositoryImpl(mockRemoteDataSource);
  });

  group('save account', () {
    const account = Account(
      id: '123',
      username: 'john_doe',
      bio: 'Sample bio',
      name: 'John Doe',
      email: 'john@example.com',
      photoUrl: 'https://example.com/photo.jpg',
      phoneNumber: '+1234567890',
      contacts: KtList.empty(),
    );

    final accountDto = AccountDto.fromDomain(account);

    test('should save an account when succeed', () async {
      // Arrange
      when(mockRemoteDataSource.saveAccount(any))
          .thenAnswer((_) async => right(unit));

      // Act
      final result = await sut.saveAccount(account);

      // Assert
      expect(result, isA<Right>());
      verify(mockRemoteDataSource.saveAccount(accountDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });

    test('should return a failure when saving account fails', () async {
      // Arrange
      const failure = Failure.unexpectedError();
      when(mockRemoteDataSource.saveAccount(accountDto)).thenThrow(failure);

      // Act
      final result = await sut.saveAccount(account);

      // Assert
      expect(result, equals(left(failure)));
      verify(mockRemoteDataSource.saveAccount(accountDto)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
    });
  });

  group('watchAccount', () {
    const accountDto = AccountDto(
      id: '1',
      username: 'test_user',
      bio: 'Test bio',
      name: 'Test User',
      email: 'test@example.com',
      photoUrl: 'https://example.com/test_photo.jpg',
      phoneNumber: '+1234567890',
      contacts: ['contact1', 'contact2'],
    );
    final account = accountDto.toDomain();
    test('should return Account stream from remote data source', () {
      // Arrange

      when(mockRemoteDataSource.watchCurrentAccount())
          .thenAnswer((_) => Stream.value(accountDto));

      // Act
      final result = sut.watchAccount();

      // Assert
      expect(result, emitsInOrder([right(account)]));
    });

    test('should return server error when account is null', () {
      // Arrange
      when(mockRemoteDataSource.watchCurrentAccount())
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchAccount();

      // Assert
      expect(result, emitsInOrder([left(const Failure.serverError())]));
    });
  });

  group('watchAccounts', () {
    final accountDtoList = [
      const AccountDto(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'https://example.com/test_photo.jpg',
        phoneNumber: '+1234567890',
        contacts: ['contact1', 'contact2'],
      ),
      const AccountDto(
        id: '2',
        username: 'test_user2',
        bio: 'Test bio',
        name: 'Test User 2',
        email: 'test2@example.com',
        photoUrl: 'https://example.com/test_photo.jpg',
        phoneNumber: '+1234567890',
        contacts: ['contact1', 'contact2'],
      )
    ];
    test('should return list of Accounts from remote data source', () {
      // Arrange
      final accountList =
          accountDtoList.map((e) => e.toDomain()).toImmutableList();
      when(mockRemoteDataSource.watchAccounts(username: anyNamed('username')))
          .thenAnswer((_) => Stream.value(accountDtoList));

      // Act
      final result = sut.watchAccounts();

      // Assert
      expect(result, emitsInOrder([right(accountList)]));
    });

    test('should return empty list when account list is null', () {
      // Arrange
      when(mockRemoteDataSource.watchAccounts(username: anyNamed('username')))
          .thenAnswer((_) => Stream.value(null));

      // Act
      final result = sut.watchAccounts();

      // Assert
      expect(result, emitsInOrder([right(const KtList.empty())]));
    });

    test('should return server error when an error occurs', () {
      // Arrange
      when(mockRemoteDataSource.watchAccounts(username: anyNamed('username')))
          .thenAnswer((_) => Stream.error(const Failure.serverError()));

      // Act
      final result = sut.watchAccounts();

      // Assert
      expect(result, emitsInOrder([left(const Failure.serverError())]));
    });
  });

  group('setOnlineStatus', () {
    test('should update online status on remote data source', () async {
      // Arrange
      const bool status = true;
      when(mockRemoteDataSource.updateOnlineStatus(any))
          .thenAnswer((_) async {});

      // Act
      final result = await sut.setOnlineStatus(status);

      // Assert
      expect(result, equals(right(unit)));
    });

    test('should return a failure when updating online status fails', () async {
      // Arrange
      const bool status = true;
      const failure = Failure.unexpectedError();
      when(mockRemoteDataSource.updateOnlineStatus(any)).thenThrow(failure);

      // Act
      final result = await sut.setOnlineStatus(status);

      // Assert
      expect(result, equals(left(failure)));
    });
  });
}
