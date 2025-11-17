import 'package:fpdart/fpdart.dart';

import '../../core/core.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenService tokenService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenService,
  });

  @override
  Future<Either<AppFailure, String?>> authenticate({
    required String login,
    required String password,
  }) async {
    final result = await remoteDataSource.authenticate(
      login: login,
      password: password,
    );

    return result.fold(
      (failure) => Left(failure),
      (token) async {
        await tokenService.saveToken(token);
        return Right(token);
      },
    );
  }
}
