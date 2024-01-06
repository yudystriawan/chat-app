import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/errors/failure.dart';
import '../../../../utils/usecases/usecase.dart';
import '../repositories/image_repository.dart';

@injectable
class UploadImage implements Usecase<String, UploadImageParams> {
  final ImageRepository _imageRepository;

  UploadImage(this._imageRepository);

  @override
  Future<Either<Failure, String>> call(params) {
    return _imageRepository.uploadImage(
      imageFile: params.imageFile,
      fullPath: params.fullPath,
      metadata: params.metadata,
    );
  }
}

class UploadImageParams {
  final File imageFile;
  final String fullPath;
  final Map<String, String>? metadata;

  UploadImageParams(
    this.imageFile,
    this.fullPath,
    this.metadata,
  );
}
