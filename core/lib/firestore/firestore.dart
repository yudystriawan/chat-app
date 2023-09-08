import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

export 'package:cloud_firestore/cloud_firestore.dart' show FieldValue;

@injectable
class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  FirebaseFirestore get instance => _firestore;
}
