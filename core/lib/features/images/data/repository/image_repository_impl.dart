import 'dart:io';

import 'package:core/features/images/data/data_sources/image_remote_data_source.dart';
import 'package:core/utils/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/image_repository.dart';

@Injectable(as: ImageRepository)
class ImageRepositoryImpl implements ImageRepository {
  final ImageRemoteDataSource _remoteDataSource;

  ImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> uploadImage(File file) async {
    try {
      final downloadUrl = await _remoteDataSource.uploadImage(file);
      return right(downloadUrl ?? '');
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}
