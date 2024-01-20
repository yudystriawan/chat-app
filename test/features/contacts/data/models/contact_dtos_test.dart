import 'package:chat_app/features/account/domain/entities/account.dart';
import 'package:chat_app/features/contacts/data/models/contact_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('ContactDto', () {
    // Test case for checking if ContactDto can be created from a domain object
    test('fromDomain should create ContactDto from Account', () {
      // Arrange
      final account = Account(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test Name',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: KtList.from(['contact1', 'contact2']),
      );

      // Act
      final contactDto = ContactDto.fromDomain(account);

      // Assert
      expect(contactDto.id, account.id);
      expect(contactDto.username, account.username);
      expect(contactDto.bio, account.bio);
      expect(contactDto.name, account.name);
      expect(contactDto.email, account.email);
      expect(contactDto.photoUrl, account.photoUrl);
      expect(contactDto.phoneNumber, account.phoneNumber);
      expect(contactDto.contacts, account.contacts.iter.toList());
    });

    // Test case for checking if ContactDto can be converted to domain object
    test('toDomain should create Contact from ContactDto', () {
      // Arrange
      const contactDto = ContactDto(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test Name',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: ['contact1', 'contact2'],
      );

      // Act
      final contact = contactDto.toDomain();

      // Assert
      expect(contact.id, contactDto.id);
      expect(contact.username, contactDto.username);
      expect(contact.bio, contactDto.bio);
      expect(contact.name, contactDto.name);
      expect(contact.email, contactDto.email);
      expect(contact.photoUrl, contactDto.photoUrl);
      expect(contact.phoneNumber, contactDto.phoneNumber);
      expect(contact.contacts, KtList.from(contactDto.contacts!));
    });

    // Test case for checking if ContactDto can be converted to and from JSON
    test('toJson and fromJson should be consistent', () {
      // Arrange
      const contactDto = ContactDto(
        id: '1',
        username: 'test_user',
        bio: 'Test bio',
        name: 'Test Name',
        email: 'test@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: ['contact1', 'contact2'],
      );

      // Act
      final json = contactDto.toJson();
      final fromJson = ContactDto.fromJson(json);

      // Assert
      expect(fromJson, contactDto);
    });
  });
}
