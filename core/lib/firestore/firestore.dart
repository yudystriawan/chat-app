import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

export 'package:cloud_firestore/cloud_firestore.dart'
    show FieldValue, FieldPath, Timestamp;

@injectable
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  FirebaseFirestore get instance => _firestore;
}

class ServerTimestampConverter implements JsonConverter<Timestamp, Object> {
  const ServerTimestampConverter();

  @override
  Timestamp fromJson(Object json) => json as Timestamp;

  @override
  Object toJson(Timestamp object) => FieldValue.serverTimestamp();
}
