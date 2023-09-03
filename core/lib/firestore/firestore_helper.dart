import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference get userCollection => collection('users');
  Future<DocumentReference> userDocument() async {
    final user = getIt<FirebaseAuth>().currentUser;

    if (user == null) throw const Failure.unauthenticated();

    return userCollection.doc(user.uid);
  }
}
