import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/services/firestore/firestore_helper.dart';
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

  MessageRemoteDataSourceImpl(this._service);

  @override
  Future<MessageDto?> createMessage({
    required String roomId,
    required MessageDto message,
  }) async {
    try {
      final messageCollection =
          _service.instance.roomCollection.doc(roomId).collection('messages');

      // get current user
      final userId = _service.instance.currentUser!.uid;

      // modify message payload
      final messageId = messageCollection.doc().id;

      final request = message
          .copyWith(
            id: messageId,
            sentBy: userId,
          )
          .toJson();

      // add server timestamp
      request.addAll({'sentAt': FieldValue.serverTimestamp()});

      // create message
      await messageCollection.doc(messageId).set(request);

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
    var query = _service.instance.roomCollection
        .doc(roomId)
        .collection('messages')
        .orderBy('sentAt', descending: true);

    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    return query
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageDto.fromJson(doc.data()))
            .toList())
        .onErrorReturnWith((error, stackTrace) {
      log('fetchMessages',
          name: runtimeType.toString(), error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Stream<List<MessageDto>?> watchUnreadMessages(String roomId) {
    final userId = _service.instance.currentUser?.uid;

    return _service.instance.roomCollection
        .doc(roomId)
        .collection('messages')
        .where(
          'sentBy',
          isNotEqualTo: userId,
        )
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MessageDto.fromJson(doc.data()))
            .toList())
        .map((messages) => messages
            .where((message) =>
                message.readInfoList
                    ?.every((readInfo) => readInfo.uid != userId) ??
                true)
            .toList())
        .onErrorReturnWith((error, stackTrace) {
      log('fetchUnreadMessages',
          name: runtimeType.toString(), error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Stream<MessageDto?> watchLastMessage(String roomId) {
    return _service.instance.roomCollection
        .doc(roomId)
        .collection('messages')
        .orderBy('sentAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => MessageDto.fromJson(doc.data())).toList())
        .map((messages) => messages.first)
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
      final messageCollection =
          _service.instance.roomCollection.doc(roomId).collection('messages');

      final request = message.toJson();

      // update message
      await messageCollection.doc(message.id).update(request);

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
      final doc = await _service.instance.roomCollection
          .doc(roomId)
          .collection('messages')
          .doc(messageId)
          .get();

      final message = MessageDto.fromJson(doc.data() as Map<String, dynamic>);

      return message;
    } catch (e, s) {
      log('fetchMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
