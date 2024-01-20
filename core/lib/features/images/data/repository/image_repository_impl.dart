import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../utils/errors/failure.dart';
import '../../domain/repositories/image_repository.dart';
import '../data_sources/image_remote_data_source.dart';

@Injectable(as: ImageRepository)
class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;

  ImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadImage({
    required File imageFile,
    required String fullPath,
    Map<String, String>? metadata,
  }) async {
    try {
      final downloadUrl = await _remoteDataSource.uploadImage(
        imageFile: imageFile,
        fullPath: fullPath,
        metadata: metadata,
      );

      return right(downloadUrl ?? '');
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}
