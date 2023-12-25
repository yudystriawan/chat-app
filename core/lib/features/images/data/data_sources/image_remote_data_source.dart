// ignore_for_file: unused_import

import 'dart:io';

import 'package:core/core.dart';
import 'package:core/services/auth/auth_service.dart';
import 'package:core/services/firebase_storage/storage.dart';
import 'package:core/services/firebase_storage/storage_helper.dart';
import 'package:core/services/firestore/firestore_helper.dart';
import 'package:injectable/injectable.dart';
import 'package:path/path.dart' as p;

abstract class ImageRemoteDataSource {
  Future<String?> uploadImage(File imageFile);
}

@Injectable(as: ImageRemoteDataSource)
class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final StorageService _storageService;
  final AuthService _authService;

  ImageRemoteDataSourceImpl(
    this._storageService,
    this._authService,
  );
  @override
  Future<String?> uploadImage(File imageFile) async {
    try {
      final uid = _authService.currentUser!.uid;
      String targetPath = 'room_$uid.${p.extension(imageFile.path)}';

      final imageRef =
          _storageService.instance.imageRef.child(uid).child(targetPath);

      await imageRef.putFile(imageFile);

      final downloadUrl = await imageRef.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw const Failure.serverError();
    }
  }
}
