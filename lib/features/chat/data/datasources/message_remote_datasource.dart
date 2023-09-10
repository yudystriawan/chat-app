import 'dart:developer';

import 'package:chat_app/features/chat/data/models/message_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

abstract class MessageRemoteDataSource {
  Future<void> createMessage({
    required String roomId,
    required MessageDto message,
  });
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

      final request = message.copyWith(
        id: messageId,
        sentBy: userId,
        sentAt: FieldValue.serverTimestamp(),
      );

      // create message
      await messageCollection.doc(messageId).set(request.toJson()).then(
          (_) => log('message created with ID $messageId in roomId: $roomId'));
    } catch (e, s) {
      log('createMessage',
          name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }
}
