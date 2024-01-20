import 'package:chat_app/features/account/data/models/account_dtos.dart';
import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('AccountDto', () {
    test('fromJson should return a valid AccountDto', () {
      // Arrange
      final Map<String, dynamic> json = {
        'id': '1',
        'username': 'test_user',
        'bio': 'Test bio',
        'name': 'Test User',
        'email': 'test@example.com',
        'photoUrl': 'https://example.com/test_photo.jpg',
        'phoneNumber': '+1234567890',
        'contacts': ['contact1', 'contact2'],
      };

      // Act
      final result = AccountDto.fromJson(json);

      // Assert
      expect(result, isA<AccountDto>());
      expect(result.id, json['id']);
      expect(result.username, json['username']);
      expect(result.bio, json['bio']);
      expect(result.name, json['name']);
      expect(result.email, json['email']);
      expect(result.photoUrl, json['photoUrl']);
      expect(result.phoneNumber, json['phoneNumber']);
      expect(result.contacts, json['contacts']);
    });

    test('fromDomain should convert an Account to AccountDto', () {
      // Arrange
      final account = Account(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test User',
        email: 'test@example.com',
        photoUrl: 'https://example.com/test_photo.jpg',
        phoneNumber: '+1234567890',
        contacts: KtList.from(['contact1', 'contact2']),
      );

      // Act
      final result = AccountDto.fromDomain(account);

      // Assert
      expect(result, isA<AccountDto>());
      expect(result.id, account.id);
      expect(result.username, account.username);
      expect(result.bio, account.bio);
      expect(result.name, account.name);
      expect(result.email, account.email);
      expect(result.photoUrl, account.photoUrl);
      expect(result.phoneNumber, account.phoneNumber);
      expect(result.contacts, account.contacts.iter.toList());
      expect(result.contacts, isNotNull);
    });

    test('toDomain should convert AccountDto to Account', () {
      // Arrange
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

      // Act
      final result = accountDto.toDomain();

      // Assert
      expect(result, isA<Account>());
      expect(result.id, accountDto.id);
      expect(result.username, accountDto.username);
      expect(result.bio, accountDto.bio);
      expect(result.name, accountDto.name);
      expect(result.email, accountDto.email);
      expect(result.photoUrl, accountDto.photoUrl);
      expect(result.phoneNumber, accountDto.phoneNumber);
      expect(result.contacts, KtList.from(accountDto.contacts!));
    });

    test('toJson should convert AccountDto to Map<String, dynamic>', () {
      // Arrange
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

      // Act
      final result = accountDto.toJson();

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['id'], '1');
      expect(result['username'], 'test_user');
      expect(result['bio'], 'Test bio');
      expect(result['name'], 'Test User');
      expect(result['email'], 'test@example.com');
      expect(result['photoUrl'], 'https://example.com/test_photo.jpg');
      expect(result['phoneNumber'], '+1234567890');
      expect(result['contacts'], ['contact1', 'contact2']);
    });
  });
}
