import 'dart:developer';
import 'dart:io';

import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/services/storage/storage_service.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;
import 'package:rxdart/rxdart.dart';

import '../models/message_dtos.dart';

abstract class MessageRemoteDataSource {
  Future<void> upsertMessage({
    required String roomId,
    required MessageDto message,
    File? image,
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
  final FirestoreService _firestoreService;
  final AuthService _authService;
  final StorageService _storageService;

  MessageRemoteDataSourceImpl(
    this._firestoreService,
    this._authService,
    this._storageService,
  );

  @override
  Future<void> upsertMessage({
    required String roomId,
    required MessageDto message,
    File? image,
  }) async {
    try {
      final collectionPath = 'rooms/$roomId/messages';

      // get current user
      final userId = _authService.currentUser!.uid;

      // modify message payload
      String? messageId = message.id;
      messageId ??= _firestoreService.generateId();

      // upload image
      String? downloadUrl;
      if (image != null) {
        final result = await _storageService.uploadImage(
          fullPath: 'rooms/$roomId/$messageId.${p.extension(image.path)}',
          image: image,
        );
        downloadUrl = result;
      }

      final request = message
          .copyWith(id: messageId, sentBy: userId, imageUrl: downloadUrl)
          .toJson();

      await _firestoreService.upsert(collectionPath, messageId, request);

      return;
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
    return _firestoreService
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

    return _firestoreService
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
    return _firestoreService
        .watchAll('rooms/$roomId/messages',
            orderConditions: [OrderCondition('sentAt', descending: true)],
            limit: 1)
        .map((docs) {
      if (docs.isNotEmpty) return MessageDto.fromJson(docs[0]);
      return null;
    }).onErrorReturnWith((error, stackTrace) {
      log('watchLastMessage',
          name: runtimeType.toString(), error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Future<MessageDto?> fetchMessage({
    required String roomId,
    required String messageId,
  }) async {
    try {
      final result = await _firestoreService
          .watch('rooms/$roomId/messages', messageId)
          .first;

      final message = MessageDto.fromJson(result!);

      return message;
    } catch (e, s) {
      log('fetchMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
