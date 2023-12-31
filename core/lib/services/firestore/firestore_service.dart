import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

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
    List<WhereCondition>? orConditions,
    int? limit,
  }) {
    if (orConditions != null) {
      assert(
        orConditions.length >= 2 && orConditions.length <= 10,
        'OR conditions length must be between 2 and 10',
      );
    }

    Query<Map<String, dynamic>> query = _firestore.collection(collectionPath);

    if (whereConditions != null && whereConditions.isNotEmpty) {
      for (final condition in whereConditions) {
        query = query.where(
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

    if (orConditions != null) {
      final filterOr = WhereCondition.or(orConditions);
      query = query.where(filterOr);
    }

    if (orderConditions != null && orderConditions.isNotEmpty) {
      for (var order in orderConditions) {
        query = query.orderBy(order.field, descending: order.descending);
      }
    }

    if (limit != null && limit > 0) {
      query = query.limit(limit);
    }

    return query
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
    final options = SetOptions(merge: true);
    return _firestore.collection(collectionPath).doc(docId).set(data, options);
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

  void useEmulator(String host, int port) =>
      _firestore.useFirestoreEmulator(host, port);
}

class ServerTimestampConverter
    implements JsonConverter<ServerTimestamp?, dynamic> {
  const ServerTimestampConverter();

  @override
  ServerTimestamp? fromJson(json) => ServerTimestamp.create(json);

  @override
  toJson(ServerTimestamp? object) {
    if (object == null || object.isAlways) return FieldValue.serverTimestamp();

    return object.timestamp ?? FieldValue.serverTimestamp();
  }
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

  static Filter or(List<WhereCondition?> conditions) {
    final length = conditions.length;
    return Filter.or(
      _mapFilter(conditions[0])!,
      _mapFilter(conditions[1])!,
      _hasElementIndex(2, length) ? _mapFilter(conditions[2]) : null,
      _hasElementIndex(3, length) ? _mapFilter(conditions[3]) : null,
      _hasElementIndex(4, length) ? _mapFilter(conditions[4]) : null,
      _hasElementIndex(5, length) ? _mapFilter(conditions[5]) : null,
      _hasElementIndex(6, length) ? _mapFilter(conditions[6]) : null,
      _hasElementIndex(7, length) ? _mapFilter(conditions[7]) : null,
      _hasElementIndex(8, length) ? _mapFilter(conditions[8]) : null,
      _hasElementIndex(9, length) ? _mapFilter(conditions[9]) : null,
    );
  }

  static bool _hasElementIndex(int index, int length) {
    return index < length;
  }

  static Filter? _mapFilter(WhereCondition? condition) {
    if (condition == null) return null;
    return Filter(
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

class OrderCondition {
  final String field;
  final bool descending;

  OrderCondition(
    this.field, {
    this.descending = false,
  });
}

class FieldArray {
  final List<dynamic> data;

  FieldArray(this.data);

  FieldValue union() => FieldValue.arrayUnion(data);
  FieldValue remove() => FieldValue.arrayRemove(data);
}

enum TimestampType { ifNotSet, always }

class ServerTimestamp {
  Timestamp? _timestamp;
  TimestampType _type = TimestampType.ifNotSet;

  ServerTimestamp.create([dynamic value]) {
    if (value is ServerTimestamp) {
      _timestamp = value.timestamp;
      return;
    }

    if (value is DateTime) {
      _timestamp = Timestamp.fromDate(value);
      return;
    }

    if (value is Timestamp) {
      _timestamp = value;
      return;
    }

    _timestamp = Timestamp.fromDate(DateTime.now());
  }

  ServerTimestamp config(TimestampType type) {
    _type = type;
    return this;
  }

  bool get isAlways => _type == TimestampType.always;
  bool get isIfNotSet => _type == TimestampType.ifNotSet;

  Timestamp? get timestamp => _timestamp;
  DateTime? toDate() => timestamp?.toDate();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServerTimestamp &&
        other._timestamp == _timestamp &&
        other._type == _type;
  }

  @override
  int get hashCode => _timestamp.hashCode ^ _type.hashCode;
}
