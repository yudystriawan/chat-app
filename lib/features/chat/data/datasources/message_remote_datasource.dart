import 'dart:developer';

import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

abstract class MessageRemoteDataSource {
  Future<void> createMessage({
    required String roomId,
    required MessageDto message,
  });
  Stream<List<MessageDto>?> fetchMessages(String roomId);
}

@Injectable(as: MessageRemoteDataSource)
class MessageRemoteDataSourceImpl implements MessageRemoteDataSource {
  final FirestoreService _service;

  MessageRemoteDataSourceImpl(this._service);

  @override
  Future<void> createMessage({
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
      await messageCollection.doc(messageId).set(request).then(
          (_) => log('message created with ID $messageId in roomId: $roomId'));
    } catch (e, s) {
      log('createMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }

  @override
  Stream<List<MessageDto>?> fetchMessages(String roomId) {
    return _service.instance.roomCollection
        .doc(roomId)
        .collection('messages')
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
}
