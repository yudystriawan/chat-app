import 'dart:io';

import 'package:core/core.dart';
import 'package:core/services/storage/storage_service.dart';
import 'package:injectable/injectable.dart';

abstract class ImageRemoteDataSource {
  Future<String?> uploadImage({
    required File imageFile,
    required String fullPath,
    Map<String, String>? metadata,
  });
}

@Injectable(as: ImageRemoteDataSource)
class ImageRemoteDataSourceImpl implements ImageRemoteDataSource {
  final StorageService _storageService;

  ImageRemoteDataSourceImpl(
    this._storageService,
  );

  @override
  Future<String?> uploadImage({
    required File imageFile,
    required String fullPath,
    Map<String, String>? metadata,
  }) async {
    try {
      return _storageService.uploadImage(
        fullPath: fullPath,
        image: imageFile,
        metadata: metadata,
      );
    } catch (e) {
      throw const Failure.serverError();
    }
  }
}
