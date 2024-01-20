import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:core/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('Account', () {
    test('Account should be created with the provided values', () {
      final account = Account(
        id: '123',
        username: 'john_doe',
        bio: 'Sample bio',
        name: 'John Doe',
        email: 'john@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '+1234567890',
        contacts: KtList.from(['contact1', 'contact2']),
      );

      expect(account.id, '123');
      expect(account.username, 'john_doe');
      expect(account.bio, 'Sample bio');
      expect(account.name, 'John Doe');
      expect(account.email, 'john@example.com');
      expect(account.photoUrl, 'https://example.com/photo.jpg');
      expect(account.phoneNumber, '+1234567890');
      expect(account.contacts, KtList.from(['contact1', 'contact2']));
    });

    test(
        'Account should be created with empty values using factory constructor',
        () {
      final emptyAccount = Account.empty();

      expect(emptyAccount.id, '');
      expect(emptyAccount.username, '');
      expect(emptyAccount.bio, '');
      expect(emptyAccount.name, '');
      expect(emptyAccount.email, '');
      expect(emptyAccount.photoUrl, '');
      expect(emptyAccount.phoneNumber, '');
      expect(emptyAccount.contacts, const KtList.empty());
    });

    test('Account should be created from a User object', () {
      final user = User(
        id: '456',
        username: 'jane_doe',
        bio: 'Another bio',
        name: 'Jane Doe',
        email: 'jane@example.com',
        photoUrl: 'https://example.com/jane_photo.jpg',
        phoneNumber: '+9876543210',
        contacts: KtList.from(['contact3', 'contact4']),
      );

      final accountFromUser = Account.fromUser(user);

      expect(accountFromUser.id, user.id);
      expect(accountFromUser.username, user.username);
      expect(accountFromUser.bio, user.bio);
      expect(accountFromUser.name, user.name);
      expect(accountFromUser.email, user.email);
      expect(accountFromUser.photoUrl, user.photoUrl);
      expect(accountFromUser.phoneNumber, user.phoneNumber);
      expect(accountFromUser.contacts, user.contacts);
    });

    test('isEmpty should return true for an empty account', () {
      final emptyAccount = Account.empty();
      expect(emptyAccount.isEmpty, true);
    });

    test('isEmpty should return false for a non-empty account', () {
      final nonEmptyAccount = Account(
        id: '789',
        username: 'mary_doe',
        bio: 'Yet another bio',
        name: 'Mary Doe',
        email: 'mary@example.com',
        photoUrl: 'https://example.com/mary_photo.jpg',
        phoneNumber: '+1122334455',
        contacts: KtList.from(['contact5', 'contact6']),
      );

      expect(nonEmptyAccount.isEmpty, false);
    });
  });
}
