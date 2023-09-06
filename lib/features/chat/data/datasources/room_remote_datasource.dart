import 'dart:developer';

import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

abstract class RoomRemoteDataSource {
  Future<String> createRoom(RoomDto room);
  Future<void> deleteRoom(String roomId);
}

@Injectable(as: RoomRemoteDataSource)
class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirestoreService _service;

  RoomRemoteDataSourceImpl(this._service);

  @override
  Future<String> createRoom(RoomDto room) async {
    try {
      // get current user
      final user = _service.instance.currentUser!;
      final userIds = room.userIds?.toList();
      userIds?.add(user.uid);

      // check if room exist, return the existing id
      final snapshot = await _service.instance.roomCollection
          .where(
            'userIds',
            arrayContainsAny: userIds,
          )
          .get();
      if (snapshot.docs.isNotEmpty && snapshot.docs.first.exists) {
        final roomId = snapshot.docs.first.id;
        log('room already exist with ID $roomId');
        return roomId;
      }

      // get a generated id
      var roomId = _service.instance.roomCollection.doc().id;

      // add createdAt field with server timestamp
      // add createdBy with current userId
      final request = room.copyWith(
        id: roomId,
        createdAt: DateTime.now().toIso8601String(),
        createdBy: user.uid,
        userIds: userIds,
      );

      await _service.instance.roomCollection
          .doc(roomId)
          .set(request.toJson())
          .then((_) => log('room created with ID $roomId'));

      return roomId;
    } catch (e, s) {
      log('createRoom', name: runtimeType.toString(), error: e, stackTrace: s);
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> deleteRoom(String roomId) async {
    try {
      await _service.instance.roomCollection.doc(roomId).delete();
    } catch (e) {
      throw const Failure.serverError();
    }
  }
}
