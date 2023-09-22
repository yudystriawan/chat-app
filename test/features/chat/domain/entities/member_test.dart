import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Member', () {
    test('Member.empty() should create a member with default values', () {
      final member = Member.empty();

      expect(member.name, '');
      expect(member.imageUrl, '');
      expect(member.id, '');
    });

    test('Member should be created with specified values', () {
      const member = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      expect(member.name, 'John Doe');
      expect(member.imageUrl, 'john.jpg');
      expect(member.id, '123');
    });

    test('Member should be equal when all properties are the same', () {
      const member1 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      const member2 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      expect(member1, equals(member2));
    });

    test('Member should not be equal when at least one property is different',
        () {
      const member1 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      const member2 = Member(
        name: 'Jane Smith', // Different name
        imageUrl: 'john.jpg',
        id: '123',
      );

      expect(member1, isNot(equals(member2)));
    });

    test(
        'Member should be equal when comparing to a copy with the same properties',
        () {
      const member1 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      final memberCopy = member1.copyWith();

      expect(member1, equals(memberCopy));
    });

    test(
        'Member.copyWith() should create a new instance with updated properties',
        () {
      const member1 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      final updatedMember = member1.copyWith(name: 'Jane Smith', id: '456');

      expect(updatedMember.name, 'Jane Smith');
      expect(updatedMember.imageUrl,
          'john.jpg'); // imageUrl should remain the same
      expect(updatedMember.id, '456');
    });

    test('Member.copyWith() should not modify the original member', () {
      const member1 = Member(
        name: 'John Doe',
        imageUrl: 'john.jpg',
        id: '123',
      );

      final updatedMember = member1.copyWith(name: 'Jane Smith', id: '456');

      expect(updatedMember.name, 'Jane Smith');
      expect(member1.name, 'John Doe');
      expect(member1.id, '123');
    });
  });
}
