import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../utils/errors/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

@Injectable(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDatasource;

  AuthRepositoryImpl(this._remoteDatasource);

  @override
  Future<Either<Failure, Unit>> loginWithGoogle() async {
    try {
      final user = await _remoteDatasource.loginWithGoogle();

      if (user == null) return left(const Failure.canceledByUser());

      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDatasource.signOut();
      return right(unit);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(const Failure.unexpectedError());
    }
  }

  @override
  Stream<Either<Failure, User>> watchCurrentUser() {
    return _remoteDatasource.watchCurrentUser().map((userDto) {
      if (userDto == null) return right<Failure, User>(User.empty());
      return right<Failure, User>(userDto.toDomain());
    }).onErrorReturnWith((error, stackTrace) {
      if (error is Failure) return left(error);
      return left(const Failure.unexpectedError());
    });
  }
}
