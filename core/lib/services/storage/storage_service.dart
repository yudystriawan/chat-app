import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:injectable/injectable.dart';

@injectable
class StorageService {
  final FirebaseStorage _storage;

  StorageService(this._storage);

  // upload an image an return a downloadURL
  Future<String?> uploadImage({
    required String fullPath,
    required File image,
    Map<String, String>? metadata,
  }) async {
    // Create a storage reference from our app
    final storageRef = _storage.ref();

    final imageRef = storageRef.child('images/$fullPath');

    SettableMetadata? settableMetadata;
    if (metadata != null) {
      settableMetadata = SettableMetadata(customMetadata: metadata);
    }

    await imageRef.putFile(image, settableMetadata);

    return imageRef.getDownloadURL();
  }
}
