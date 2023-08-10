import 'package:chat_app/core/errors/failure.dart';
import 'package:chat_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:chat_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

import '../../domain/entities/user.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, User>> loginWithGoogle() async {
    try {
      final user = await _remoteDatasource.loginWithGoogle();

      if (user == null) return left(const Failure.canceledByUser());

      return right(user.toDomain());
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }
}
