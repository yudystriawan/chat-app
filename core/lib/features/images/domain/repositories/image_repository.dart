import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required String fullPath,
    Map<String, String>? metadata,
  });
}
