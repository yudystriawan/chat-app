import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

export 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FieldPath, Timestamp;

@lazySingleton
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Stream<List<Map<String, dynamic>>> watchAll(
    String collectionPath, {
    List<Map<String, dynamic>>? fields,
  }) {
    final collection = _firestore.collection(collectionPath);

    if (fields != null && fields.isNotEmpty) {
      for (var field in fields) {
        collection.where(field.keys, isEqualTo: field.values);
      }
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
}

class ServerTimestampConverter implements JsonConverter<Timestamp, Object> {
  const ServerTimestampConverter();

  @override
  Timestamp fromJson(Object json) => json as Timestamp;

  @override
  Object toJson(Timestamp object) => object;
}
