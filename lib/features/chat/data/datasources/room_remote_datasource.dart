import 'dart:developer';

import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';

abstract class RoomRemoteDataSource {
  Future<String> createRoom(RoomDto room);
  Future<void> deleteRoom(String roomId);
  Stream<List<RoomDto>?> fetchRooms();
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
      final members = room.members?.toList();
      members?.add(user.uid);

      // check if room exist, return the existing members
      final snapshot = await _service.instance.roomCollection
          .where(
            'members',
            arrayContainsAny: members,
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
        createdBy: user.uid,
        members: members,
        createdAt: FieldValue.serverTimestamp(),
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

  @override
  Stream<List<RoomDto>?> fetchRooms() {
    // get current user id
    final userId = _service.instance.currentUser!.uid;

    // get room documents
    return _service.instance.roomCollection
        .where('members', arrayContains: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoomDto.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
