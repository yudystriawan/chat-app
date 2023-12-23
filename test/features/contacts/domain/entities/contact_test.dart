import 'package:chat_app/features/contacts/domain/entities/contact.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('Contact', () {
    test('should create a Contact instance with the provided values', () {
      // Arrange
      final contact = Contact(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test Name',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        isOnline: true,
        contacts: KtList.from(['contact1', 'contact2']),
      );

      // Act & Assert
      expect(contact.id, '1');
      expect(contact.username, 'test_user');
      expect(contact.bio, 'Test bio');
      expect(contact.name, 'Test Name');
      expect(contact.email, 'test@example.com');
      expect(contact.photoUrl, 'https://example.com/photo.jpg');
      expect(contact.phoneNumber, '1234567890');
      expect(contact.isOnline, true);
      expect(contact.contacts, ['contact1', 'contact2'].toImmutableList());
    });

    test('should create an empty Contact instance', () {
      // Arrange
      final emptyContact = Contact.empty();

      // Act & Assert
      expect(emptyContact.id, '');
      expect(emptyContact.username, '');
      expect(emptyContact.bio, '');
      expect(emptyContact.name, '');
      expect(emptyContact.email, '');
      expect(emptyContact.photoUrl, '');
      expect(emptyContact.phoneNumber, '');
      expect(emptyContact.isOnline, false);
      expect(emptyContact.contacts, const KtList.empty());
    });
  });
}
