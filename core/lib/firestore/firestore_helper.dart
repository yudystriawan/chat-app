import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:core/features/auth/data/datasources/firebase/auth_service.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference get userCollection => collection('users');
  Future<DocumentReference> userDocument() async {
    final user = await getIt<AuthService>().getCurrentUser();

    if (user == null) throw const Failure.unauthenticated();

    return userCollection.doc(user.uid);
  }
}
