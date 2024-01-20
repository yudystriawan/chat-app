import 'package:chat_app/features/chat/domain/entities/entity.dart';
import 'package:chat_app/features/chat/domain/reporitories/chat_repository.dart';
import 'package:chat_app/features/chat/domain/usecases/watch_members.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kt_dart/collection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'watch_members_test.mocks.dart';

@GenerateMocks([ChatRepository])
void main() {
  late WatchMembers sut;
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
    sut = WatchMembers(mockRepository);
  });

  final testIds = KtList.of('id1', 'id2');
  final testMembers = KtList<Member>.of(
    const Member(id: 'id1', name: 'Member 1', imageUrl: ''),
    const Member(id: 'id2', name: 'Member 2', imageUrl: ''),
  );

  group('WatchMembers Use Case', () {
    test('should return a list of Members from the repository', () async {
      // Arrange
      when(mockRepository.watchMembers(testIds))
          .thenAnswer((_) => Stream.value(Right(testMembers)));

      // Act
      final result = await sut(WatchMembersParams(ids: testIds)).first;

      // Assert
      expect(result, Right(testMembers));
      verify(mockRepository.watchMembers(testIds)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a Failure from the repository', () async {
      // Arrange
      const failure = Failure.invalidParameter(message: 'ids cannot be empty.');
      when(mockRepository.watchMembers(testIds))
          .thenAnswer((_) => Stream.value(const Left(failure)));

      // Act
      final result =
          await sut(const WatchMembersParams(ids: KtList.empty())).first;

      // Assert
      expect(result, const Left(failure));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
