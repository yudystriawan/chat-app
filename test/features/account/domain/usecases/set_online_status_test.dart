import 'package:chat_app/features/account/domain/repositories/account_repository.dart';
import 'package:chat_app/features/account/domain/usecases/set_online_status.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'set_online_status_test.mocks.dart';

@GenerateMocks([AccountRepository])
void main() {
  late SetOnlineStatus setOnlineStatus;
  late MockAccountRepository mockRepository;

  setUp(() {
    mockRepository = MockAccountRepository();
    setOnlineStatus = SetOnlineStatus(mockRepository);
  });

  group('SetOnlineStatus', () {
    test('should set online status and return Unit', () async {
      // Arrange
      const onlineStatusParams = SetOnlineStatusParams(onlineStatus: true);
      when(mockRepository.setOnlineStatus(any))
          .thenAnswer((_) async => const Right(unit));

      // Act
      final result = await setOnlineStatus(onlineStatusParams);

      // Assert
      expect(result, const Right(unit));
      verify(mockRepository.setOnlineStatus(true));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return a failure when setting online status fails', () async {
      // Arrange
      const onlineStatusParams = SetOnlineStatusParams(onlineStatus: true);
      const failure = Failure.unexpectedError();
      when(mockRepository.setOnlineStatus(any))
          .thenAnswer((_) async => const Left(failure));

      // Act
      final result = await setOnlineStatus(onlineStatusParams);

      // Assert
      expect(result, const Left(failure));
      verify(mockRepository.setOnlineStatus(true));
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
