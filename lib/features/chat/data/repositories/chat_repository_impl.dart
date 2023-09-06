import 'package:chat_app/features/chat/data/datasources/room_remote_datasource.dart';
import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:kt_dart/collection.dart';

import '../../domain/reporitories/chat_repository.dart';

@Injectable(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final RoomRemoteDataSource _roomRemoteDataSource;

  ChatRepositoryImpl(this._roomRemoteDataSource);
  @override
  Future<Either<Failure, Unit>> createMessage({
    required String roomId,
    required String message,
  }) {
    // TODO: implement createMessage
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, String>> addRoom({
    required KtList<String> userIds,
    required int type,
  }) async {
    try {
      final bodyRequest = RoomDto(
        userIds: userIds.iter.toList(),
        type: type,
      );

      final roomId = await _roomRemoteDataSource.createRoom(bodyRequest);

      return right(roomId);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> removeRoom(String roomId) async {
    try {
      await _roomRemoteDataSource.deleteRoom(roomId);
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}
