import 'package:chat_app/features/chat/data/models/member_dtos.dart';
import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const memberDto = MemberDto(
    name: 'John',
    imageUrl: 'example.com/john.jpg',
    id: '12345',
  );

  group('MemberDto', () {
    test('should convert to a valid Member domain', () {
      // Act
      final member = memberDto.toDomain();

      // Assert
      expect(member, isA<Member>());
      expect(member.name, 'John');
      expect(member.imageUrl, 'example.com/john.jpg');
      expect(member.id, '12345');
    });

    test(
        'should convert to a valid Member domain with default values when fields are null',
        () {
      // Arrange
      const memberDtoWithNulls = MemberDto();

      // Act
      final member = memberDtoWithNulls.toDomain();

      // Assert
      expect(member, isA<Member>());
      expect(member.name, '');
      expect(member.imageUrl, '');
      expect(member.id, '');
    });

    test(
        'should convert to a valid Member domain with default values when fields are missing',
        () {
      // Arrange
      final memberDtoWithMissingFields = <String, dynamic>{};

      // Act
      final member = MemberDto.fromJson(memberDtoWithMissingFields).toDomain();

      // Assert
      expect(member, isA<Member>());
      expect(member.name, '');
      expect(member.imageUrl, '');
      expect(member.id, '');
    });
    test('fromJson should correctly parse a JSON map', () {
      // Arrange
      final Map<String, dynamic> jsonMap = {
        'name': 'John',
        'photoUrl': 'example.com/john.jpg',
        'id': '12345',
      };

      // Act
      final memberDto = MemberDto.fromJson(jsonMap);

      // Assert
      expect(memberDto, isNotNull);
      expect(memberDto.name, 'John');
      expect(memberDto.imageUrl, 'example.com/john.jpg');
      expect(memberDto.id, '12345');
    });

    test('toJson should correctly convert to a JSON map', () {
      // Arrange
      const memberDto = MemberDto(
          name: 'John', imageUrl: 'example.com/john.jpg', id: '12345');

      // Act
      final jsonMap = memberDto.toJson();

      // Assert
      expect(jsonMap, isNotNull);
      expect(jsonMap['name'], 'John');
      expect(jsonMap['photoUrl'], 'example.com/john.jpg');
      expect(jsonMap['id'], '12345');
    });

    test('toJson should handle null fields', () {
      // Arrange
      const memberDto = MemberDto(name: null, imageUrl: null, id: null);

      // Act
      final jsonMap = memberDto.toJson();

      // Assert
      expect(jsonMap, isNotNull);
      expect(jsonMap['name'], isNull);
      expect(jsonMap['photoUrl'], isNull);
      expect(jsonMap['id'], isNull);
    });
  });
}
