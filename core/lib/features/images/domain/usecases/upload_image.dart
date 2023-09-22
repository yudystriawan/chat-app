import 'dart:io';

import 'package:core/features/images/domain/repositories/image_repository.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:core/utils/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadImage implements Usecase<String, UploadImageParams> {
  final ImageRepository _imageRepository;

  UploadImage(this._imageRepository);

  @override
  Future<Either<Failure, String>> call(params) {
    return _imageRepository.uploadImage(params.imageFile);
  }
}

class UploadImageParams {
  final File imageFile;

  UploadImageParams(this.imageFile);
}
