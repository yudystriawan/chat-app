import 'dart:developer';

import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../models/member_dtos.dart';
import '../models/room_dtos.dart';

abstract class RoomRemoteDataSource {
  Future<String> createRoom(RoomDto room);
  Future<void> deleteRoom(String roomId);
  Future<void> enterRoom(String roomId);
  Future<void> exitRoom(String roomId);
  Stream<List<RoomDto>?> watchRooms();
  Stream<RoomDto?> watchRoom(String roomId);
  Stream<List<MemberDto>?> watchMembers(List<String> ids);
}

@Injectable(as: RoomRemoteDataSource)
class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirestoreService _service;
  final AuthService _authService;

  RoomRemoteDataSourceImpl(
    this._service,
    this._authService,
  );

  @override
  Future<String> createRoom(RoomDto room) async {
    try {
      // get current user
      final user = _authService.currentUser!;
      final members = room.members?.toList();
      members?.add(user.uid);

      // check if room exist, return the existing members
      var rooms = await _service
          .watchAll('rooms', whereConditions: [
            WhereCondition('members', arrayContainsAny: members)
          ])
          .map((docs) => docs.map((e) => RoomDto.fromJson(e)).toList())
          .first;

      if (rooms.isNotEmpty) {
        final roomId = rooms.first.id!;
        log('room already exist with ID $roomId');
        return roomId;
      }

      // get a generated id
      var roomId = _service.generateId();

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

      await _service
          .upsert('rooms', roomId, request)
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
      await _service.delete('rooms', roomId);
    } catch (e) {
      throw const Failure.serverError();
    }
  }

  @override
  Stream<List<RoomDto>?> watchRooms() {
    // get current user id
    final userId = _authService.currentUser!.uid;

    // get room documents
    return _service
        .watchAll('rooms', whereConditions: [
          WhereCondition('members', arrayContains: userId),
          WhereCondition('messageCount', isNull: false),
          WhereCondition('messageCount', isGreaterThan: 0),
        ])
        .map((docs) => docs.map((e) => RoomDto.fromJson(e)).toList())
        .onErrorReturnWith((error, stackTrace) {
          log('fetchRooms', error: error, stackTrace: stackTrace);
          throw const Failure.serverError();
        });
  }

  @override
  Stream<List<MemberDto>?> watchMembers(List<String> ids) {
    return _service
        .watchAll('users',
            whereConditions: [WhereCondition('id', whereIn: ids)])
        .map((docs) => docs.map((e) => MemberDto.fromJson(e)).toList())
        .onErrorReturnWith((error, stackTrace) {
          log('fetchMembers', error: error, stackTrace: stackTrace);
          throw const Failure.serverError();
        });
  }

  @override
  Stream<RoomDto?> watchRoom(String roomId) {
    return _service.watch('rooms', roomId).map((json) {
      if (json == null) return null;
      return RoomDto.fromJson(json);
    }).onErrorReturnWith((error, stackTrace) {
      log('fetchRoom', error: error, stackTrace: stackTrace);
      throw const Failure.serverError();
    });
  }

  @override
  Future<void> enterRoom(String roomId) {
    try {
      final userId = _authService.currentUser?.uid;
      return _service.upsert('rooms', roomId, {
        'enteredBy': {userId: true}
      });
    } catch (e) {
      throw const Failure.serverError();
    }
  }

  @override
  Future<void> exitRoom(String roomId) {
    try {
      final userId = _authService.currentUser?.uid;
      return _service.upsert('rooms', roomId, {
        'enteredBy': {userId: false}
      });
    } catch (e) {
      throw const Failure.serverError();
    }
  }
}
