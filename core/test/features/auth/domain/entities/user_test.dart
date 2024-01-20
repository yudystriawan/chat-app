import 'package:core/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('User', () {
    test('should create an instance of User with the provided values', () {
      // Arrange
      final user = User(
        id: '1',
        username: 'john_doe',
        bio: 'Software Developer',
        name: 'John Doe',
        email: 'john.doe@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: KtList.from(['friend1', 'friend2']),
      );

      // Act & Assert
      expect(user.id, '1');
      expect(user.username, 'john_doe');
      expect(user.bio, 'Software Developer');
      expect(user.name, 'John Doe');
      expect(user.email, 'john.doe@example.com');
      expect(user.photoUrl, 'https://example.com/photo.jpg');
      expect(user.phoneNumber, '1234567890');
      expect(user.contacts.asList(), ['friend1', 'friend2']);
    });

    test('should create an empty instance of User', () {
      // Arrange
      final emptyUser = User.empty();

      // Act & Assert
      expect(emptyUser.isEmpty, true);
      expect(emptyUser.id, '');
      expect(emptyUser.username, '');
      expect(emptyUser.bio, '');
      expect(emptyUser.name, '');
      expect(emptyUser.email, '');
      expect(emptyUser.photoUrl, '');
      expect(emptyUser.phoneNumber, '');
      expect(emptyUser.contacts.isEmpty(), true);
    });
  });
}
