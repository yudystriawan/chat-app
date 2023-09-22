import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:core/core.dart';
import 'package:firebase_auth/firebase_auth.dart';

extension FirestoreX on FirebaseFirestore {
  CollectionReference get userCollection => collection('users');
  CollectionReference get roomCollection => collection('rooms');

  User? get currentUser => getIt<FirebaseAuth>().currentUser;

  Future<DocumentReference> userDocument() async {
    if (currentUser == null) throw const Failure.unauthenticated();

    return userCollection.doc(currentUser!.uid);
  }
}
