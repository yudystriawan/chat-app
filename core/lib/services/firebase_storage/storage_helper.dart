import 'package:firebase_storage/firebase_storage.dart';

extension StorageX on FirebaseStorage {
  Reference get imageRef => ref().child('images');
}
