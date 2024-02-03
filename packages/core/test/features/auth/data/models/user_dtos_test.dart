import 'package:core/features/auth/data/models/user_dtos.dart';
import 'package:core/features/auth/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';

void main() {
  group('UserDto', () {
    test('fromJson creates a UserDto from a JSON map', () {
      // Arrange
      final json = {
        'id': '123',
        'username': 'john_doe',
        'bio': 'A short bio',
        'name': 'John Doe',
        'email': 'john@example.com',
        'photoUrl': 'https://example.com/photo.jpg',
        'phoneNumber': '1234567890',
        'contacts': ['contact1', 'contact2'],
      };

      // Act
      final userDto = UserDto.fromJson(json);

      // Assert
      expect(userDto, isA<UserDto>());
      expect(userDto.id, json['id']);
      expect(userDto.username, json['username']);
      expect(userDto.bio, json['bio']);
      expect(userDto.name, json['name']);
      expect(userDto.email, json['email']);
      expect(userDto.photoUrl, json['photoUrl']);
      expect(userDto.phoneNumber, json['phoneNumber']);
      expect(userDto.contacts, json['contacts']);
    });

    test('toDomain converts UserDto to User domain entity', () {
      // Arrange
      const userDto = UserDto(
        id: '123',
        username: 'john_doe',
        bio: 'A short bio',
        name: 'John Doe',
        email: 'john@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: ['contact1', 'contact2'],
      );
      final emptyUser = User.empty();

      // Act
      final user = userDto.toDomain();

      // Assert
      expect(user, isA<User>());
      expect(user.id, userDto.id ?? emptyUser.id);
      expect(user.username, userDto.username ?? emptyUser.username);
      expect(user.bio, userDto.bio ?? emptyUser.bio);
      expect(user.name, userDto.name ?? emptyUser.name);
      expect(user.email, userDto.email ?? emptyUser.email);
      expect(user.photoUrl, userDto.photoUrl ?? emptyUser.photoUrl);
      expect(user.phoneNumber, userDto.phoneNumber ?? emptyUser.phoneNumber);
      expect(user.contacts,
          userDto.contacts?.toImmutableList() ?? emptyUser.contacts);
    });

    test('toJson converts UserDto to a JSON map', () {
      // Arrange
      const userDto = UserDto(
        id: '123',
        username: 'john_doe',
        bio: 'A short bio',
        name: 'John Doe',
        email: 'john@example.com',
        photoUrl: 'https://example.com/photo.jpg',
        phoneNumber: '1234567890',
        contacts: ['contact1', 'contact2'],
      );

      // Act
      final json = userDto.toJson();

      // Assert
      expect(json, isA<Map<String, dynamic>>());
      expect(json['id'], userDto.id);
      expect(json['username'], userDto.username);
      expect(json['bio'], userDto.bio);
      expect(json['name'], userDto.name);
      expect(json['email'], userDto.email);
      expect(json['photoUrl'], userDto.photoUrl);
      expect(json['phoneNumber'], userDto.phoneNumber);
      expect(json['contacts'], userDto.contacts);
    });
  });
}
