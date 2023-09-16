import 'dart:developer';

import 'package:chat_app/features/chat/data/models/member_dtos.dart';
import 'package:chat_app/features/chat/data/models/room_dtos.dart';
import 'package:core/core.dart';
import 'package:core/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

abstract class RoomRemoteDataSource {
  Future<String> createRoom(RoomDto room);
  Future<void> deleteRoom(String roomId);
  Future<void> enterRoom(String roomId);
  Future<void> exitRoom(String roomId);
  Stream<List<RoomDto>?> fetchRooms();
  Stream<RoomDto?> fetchRoom(String roomId);
  Stream<List<MemberDto>?> fetchMembers(List<String> ids);
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
      final request = room
          .copyWith(
            id: roomId,
            createdBy: user.uid,
            members: members,
          )
          .toJson();

      // add server timestamp
      request.addAll({'createdAt': FieldValue.serverTimestamp()});

      await _service.instance.roomCollection
          .doc(roomId)
          .set(request)
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
        .where('messageCount', isNull: false)
        .where('messageCount', isGreaterThan: 0)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => RoomDto.fromJson(doc.data() as Map<String, dynamic>))
            .toList())
        .onErrorReturnWith((error, stackTrace) {
      log('fetchRooms', error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Stream<List<MemberDto>?> fetchMembers(List<String> ids) {
    return _service.instance.userCollection
        .where(FieldPath.documentId, whereIn: ids)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map(
                (doc) => MemberDto.fromJson(doc.data() as Map<String, dynamic>))
            .toList())
        .onErrorReturnWith((error, stackTrace) {
      log('fetchMembers', error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Stream<RoomDto?> fetchRoom(String roomId) {
    return _service.instance.roomCollection
        .doc(roomId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.data() == null) return null;

      return RoomDto.fromJson(snapshot.data() as Map<String, dynamic>);
    }).onErrorReturnWith((error, stackTrace) {
      log('fetchRoom', error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Future<void> enterRoom(String roomId) {
    try {
      final userId = _service.instance.currentUser?.uid;
      return _service.instance.roomCollection.doc(roomId).update({
        'onlineUsers': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> exitRoom(String roomId) {
    try {
      final userId = _service.instance.currentUser?.uid;
      return _service.instance.roomCollection.doc(roomId).update({
        'onlineUsers': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      throw const Failure.serverError();
    }
  }
}
