import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

export 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FieldPath, Timestamp;

@lazySingleton
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(
    this._firestore,
  );

  Stream<List<Map<String, dynamic>>> watchAll(
    String collectionPath, {
    List<WhereCondition>? whereConditions,
    List<OrderCondition>? orderConditions,
    int? limit,
  }) {
    final collection = _firestore.collection(collectionPath);

    if (whereConditions != null && whereConditions.isNotEmpty) {
      for (final condition in whereConditions) {
        collection.where(
          condition.field,
          isEqualTo: condition.isEqualTo,
          arrayContains: condition.arrayContains,
          arrayContainsAny: condition.arrayContainsAny,
          isGreaterThan: condition.isGreaterThan,
          isGreaterThanOrEqualTo: condition.isGreaterThanOrEqualTo,
          isLessThan: condition.isLessThan,
          isLessThanOrEqualTo: condition.isLessThanOrEqualTo,
          isNotEqualTo: condition.isNotEqualTo,
          isNull: condition.isNull,
          whereIn: condition.whereIn,
          whereNotIn: condition.whereNotIn,
        );
      }
    }

    if (orderConditions != null && orderConditions.isNotEmpty) {
      for (var order in orderConditions) {
        collection.orderBy(order.field, descending: order.descending);
      }
    }

    if (limit != null && limit > 0) {
      collection.limit(limit);
    }

    return collection
        .snapshots()
        .map((snap) => snap.docs.map((e) => e.data()).toList());
  }

  Stream<Map<String, dynamic>?> watch(String collectionPath, String? docId) {
    return _firestore
        .collection(collectionPath)
        .doc(docId)
        .snapshots()
        .map((snap) => snap.data());
  }

  Future<void> upsert(
    String collectionPath,
    String? docId,
    Map<String, dynamic> data,
  ) async {
    return _firestore.collection(collectionPath).doc(docId).set(data);
  }

  Future<void> delete(String collectionPath, String? docId) {
    return _firestore.collection(collectionPath).doc(docId).delete();
  }

  Future<bool> checkIfExist(String collectionPath, String? docId) async {
    final snapshot =
        await _firestore.collection(collectionPath).doc(docId).get();
    return snapshot.exists;
  }

  String generateId() => const Uuid().v4();
}

class ServerTimestampConverter implements JsonConverter<Timestamp, Object> {
  const ServerTimestampConverter();

  @override
  Timestamp fromJson(Object json) => json as Timestamp;

  @override
  Object toJson(Timestamp object) => object;
}

class WhereCondition {
  final String field;
  final Object? isEqualTo;
  final Object? isNotEqualTo;
  final Object? isLessThan;
  final Object? isLessThanOrEqualTo;
  final Object? isGreaterThan;
  final Object? isGreaterThanOrEqualTo;
  final Object? arrayContains;
  final Iterable<Object?>? arrayContainsAny;
  final Iterable<Object?>? whereIn;
  final Iterable<Object?>? whereNotIn;
  final bool? isNull;

  WhereCondition(
    this.field, {
    this.isEqualTo,
    this.isNotEqualTo,
    this.isLessThan,
    this.isLessThanOrEqualTo,
    this.isGreaterThan,
    this.isGreaterThanOrEqualTo,
    this.arrayContains,
    this.arrayContainsAny,
    this.whereIn,
    this.whereNotIn,
    this.isNull,
  });
}

class OrderCondition {
  final String field;
  final bool descending;

  OrderCondition(
    this.field, {
    this.descending = false,
  });
}
