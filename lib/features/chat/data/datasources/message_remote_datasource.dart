import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/message_dtos.dart';

abstract class MessageRemoteDataSource {
  Future<MessageDto?> createMessage({
    required String roomId,
    required MessageDto message,
  });

  Future<MessageDto?> updateMessage({
    required String roomId,
    required MessageDto message,
  });

  Stream<List<MessageDto>?> fetchMessages(
    String roomId, {
    int? limit,
  });

  Stream<List<MessageDto>?> watchUnreadMessages(String roomId);

  Stream<MessageDto?> watchLastMessage(String roomId);

  Future<MessageDto?> fetchMessage({
    required String roomId,
    required String messageId,
  });
}

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final FirestoreService _service;
  final AuthService _authService;

  MessageRemoteDataSourceImpl(
    this._service,
    this._authService,
  );

  @override
  Future<MessageDto?> createMessage({
    required String roomId,
    required MessageDto message,
  }) async {
    try {
      final collectionPath = 'rooms/$roomId/messages';

      // get current user
      final userId = _authService.currentUser!.uid;

      // modify message payload
      final messageId = _service.generateId();

      final request = message
          .copyWith(
            id: messageId,
            sentBy: userId,
          )
          .toJson();

      // add server timestamp
      request.addAll({'sentAt': FieldValue.serverTimestamp()});

      await _service.upsert(collectionPath, messageId, request);

      // get message
      return fetchMessage(roomId: roomId, messageId: messageId);
    } catch (e, s) {
      log('createMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }

  @override
  Stream<List<MessageDto>?> fetchMessages(
    String roomId, {
    int? limit,
  }) {
    return _service
        .watchAll(
          'rooms/$roomId/messages',
          orderConditions: [OrderCondition('sentAt', descending: true)],
          limit: limit,
        )
        .map((docs) => docs.map((json) => MessageDto.fromJson(json)).toList())
        .onErrorReturnWith((error, stackTrace) {
      log(
        'fetchMessages',
        name: runtimeType.toString(),
        error: error,
        stackTrace: stackTrace,
      );
      throw const Failure.serverError();
    });
  }

  @override
  Stream<List<MessageDto>?> watchUnreadMessages(String roomId) {
    final userId = _authService.currentUser?.uid;

    return _service
        .watchAll(
          'rooms/$roomId/messages',
          whereConditions: [WhereCondition('sentBy', isNotEqualTo: userId)],
          orConditions: [
            WhereCondition('readBy', isEqualTo: {}),
            WhereCondition('readBy.$userId', isEqualTo: false),
          ],
        )
        .map((docs) => docs.map((e) => MessageDto.fromJson(e)).toList())
        .onErrorReturnWith((error, stackTrace) {
          log('fetchUnreadMessages',
              name: runtimeType.toString(),
              error: error,
              stackTrace: stackTrace);
          throw const Failure.serverError();
        });
  }

  @override
  Stream<MessageDto?> watchLastMessage(String roomId) {
    return _service
        .watchAll('rooms/$roomId/messages',
            orderConditions: [OrderCondition('sentAt', descending: true)],
            limit: 1)
        .map((docs) => docs.map((json) => MessageDto.fromJson(json)).toList())
        .map((messages) => messages.firstOrNull)
        .onErrorReturnWith((error, stackTrace) {
      log('watchLastMessage',
          name: runtimeType.toString(), error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Future<MessageDto?> updateMessage({
    required String roomId,
    required MessageDto message,
  }) async {
    try {
      final request = message.toJson();

      // update message
      await _service.upsert('rooms/$roomId/messages', message.id, request);

      // get message
      return fetchMessage(roomId: roomId, messageId: message.id!);
    } catch (e, s) {
      log('updateMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }

  @override
  Future<MessageDto?> fetchMessage({
    required String roomId,
    required String messageId,
  }) async {
    try {
      final result =
          await _service.watch('rooms/$roomId/messages', messageId).first;

      final message = MessageDto.fromJson(result!);

      return message;
    } catch (e, s) {
      log('fetchMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
