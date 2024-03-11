import 'package:chat_app/features/account/data/datasources/account_remote_datasource.dart';
import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'account_remote_datasource_test.mocks.dart';

@GenerateMocks([
  AuthService,
  FirestoreService,
  User,
])
void main() {
  late AccountRemoteDataSource sut;
  late MockFirestoreService mockFirestoreService;
  late MockAuthService mockAuthService;

  final user = MockUser();

  final accountDto = AccountDto(
    id: '1',
    username: 'test_user',
    bio: 'Test bio',
    name: 'Test User',
    email: 'test@example.com',
    photoUrl: 'https://example.com/test_photo.jpg',
    phoneNumber: '+1234567890',
    contacts: ['contact1', 'contact2'],
    expiredAt: ServerTimestamp.create(),
  );

  final listAccountDto = [
    accountDto,
  ];

  setUp(() {
    mockFirestoreService = MockFirestoreService();
    mockAuthService = MockAuthService();
    sut = AccountFirebaseDataSourceImpl(mockFirestoreService, mockAuthService);

    when(user.uid).thenReturn('user1');
    when(user.email).thenReturn('example.com');
    when(user.displayName).thenReturn('John Doe');
    when(user.photoURL).thenReturn('https://example.com/photo.jpg');
    when(user.phoneNumber).thenReturn('1234567890');
  });

  group('saveAccount', () {
    test('should call FirestoreService.upsert with the correct parameters',
        () async {
      // Arrange
      const accountDto = AccountDto(id: '1', username: 'test_user');
      when(mockFirestoreService.upsert(any, any, any)).thenAnswer((_) async {});

      // Act
      await sut.saveAccount(accountDto);

      // Assert
      verify(mockFirestoreService.upsert('users', '1', accountDto.toJson()))
          .called(1);
    });

    test('should rethrow Failure if FirestoreService.upsert throws a Failure',
        () async {
      // Arrange
      const accountDto = AccountDto(id: '1', username: 'test_user');
      when(mockFirestoreService.upsert(any, any, any))
          .thenThrow(const Failure.unexpectedError());

      // Act & Assert
      expect(() => sut.saveAccount(accountDto), throwsA(isA<Failure>()));
    });

    test(
        'should throw Failure.unexpectedError if FirestoreService.upsert throws an unexpected error',
        () async {
      // Arrange
      const accountDto = AccountDto(id: '1', username: 'test_user');
      when(mockFirestoreService.upsert(any, any, any)).thenThrow(Exception());

      // Act & Assert
      expect(() => sut.saveAccount(accountDto),
          throwsA(const Failure.unexpectedError()));
    });
  });

  group('watchCurrentAccount', () {
    test(
        'should return a stream of AccountDto from FirestoreService.watch and AuthService.watchCurrentUser',
        () {
      // Arrange
      when(mockAuthService.watchCurrentUser())
          .thenAnswer((_) => Stream.value(user));
      when(mockFirestoreService.watch(any, any))
          .thenAnswer((_) => Stream.value(accountDto.toJson()));

      // Act
      final result = sut.watchCurrentAccount();

      // Assert
      expectLater(result, emits(accountDto));
    });
  });

  group('watchAccounts', () {
    test(
        'should return a stream of List<AccountDto> from FirestoreService.watchAll',
        () {
      // Arrange
      when(mockFirestoreService.watchAll(
        any,
        whereConditions: anyNamed('whereConditions'),
      )).thenAnswer(
          (_) => Stream.value(listAccountDto.map((e) => e.toJson()).toList()));

      // Act
      final result = sut.watchAccounts(username: 'test_user');

      // Assert
      expectLater(result, emits(listAccountDto));
    });

    test('should throw Failure.serverError on error', () {
      // Arrange
      when(mockFirestoreService.watchAll(
        any,
        whereConditions: anyNamed('whereConditions'),
      )).thenThrow(const Failure.serverError());

      // Act and Assert
      expectLater(() => sut.watchAccounts(username: 'test_user'),
          throwsA(const TypeMatcher<Failure>()));
    });
  });

  group('updateOnlineStatus', () {
    test('should call FirestoreService.upsert with the correct parameters',
        () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.upsert(any, any, any))
          .thenAnswer((_) => Future.value());

      // Act
      await sut.updateOnlineStatus(true);

      // Assert
      verify(mockFirestoreService.upsert(any, any, any)).called(1);
    });

    test(
        'should log an error and throw Failure.serverError on unexpected error',
        () async {
      // Arrange
      when(mockAuthService.currentUser).thenReturn(user);
      when(mockFirestoreService.upsert(any, any, any)).thenThrow(Exception());

      // Act & Assert
      expectLater(() => sut.updateOnlineStatus(true),
          throwsA(const Failure.serverError()));
    });
  });

  group('remove acccount', () {
    const accountId = 'user1';
    test(
        'should remove account data from remote data source and delete auth access if has same id',
        () async {
      // Arrange
      when(mockFirestoreService.delete(any, any)).thenAnswer((_) async {});
      when(mockAuthService.deleteCurrentUser()).thenAnswer((_) async => {});
      when(mockAuthService.currentUser).thenAnswer((_) => user);

      // Act
      await sut.removeAccount(accountId);

      // Assert
      verify(mockFirestoreService.delete('users', accountId)).called(1);
      verifyNoMoreInteractions(mockFirestoreService);

      verify(mockAuthService.deleteCurrentUser()).called(1);
      verify(mockAuthService.currentUser).called(1);
      verifyNoMoreInteractions(mockAuthService);
    });

    test('should return a failure when remove account status fails', () async {
      // Arrange
      when(mockFirestoreService.delete(any, any))
          .thenThrow(const Failure.serverError());

      // Act && Assert
      expectLater(() => sut.removeAccount(accountId),
          throwsA(const Failure.serverError()));
    });
  });
}
