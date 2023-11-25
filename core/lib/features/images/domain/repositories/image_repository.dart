import 'dart:io';

import '../../../../core.dart';
import 'package:dartz/dartz.dart';

abstract class ImageRepository {
  Future<Either<Failure, String>> uploadImage(File file);
}
