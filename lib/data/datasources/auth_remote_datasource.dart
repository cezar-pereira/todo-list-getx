import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';

abstract class AuthRemoteDataSource {
  Future<Either<AppFailure, String>> authenticate({
    required String login,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final RestClient restClient;

  AuthRemoteDataSourceImpl({required this.restClient});

  @override
  Future<Either<AppFailure, String>> authenticate({
    required String login,
    required String password,
  }) async {
    try {
      final response = await restClient.post<dynamic>(
        'auth',
        headers: {'x-login': login, 'x-senha': password},
      );

      if (response.data is Map<String, dynamic>) {
        final token = response.data['token'] as String?;
        if (token != null) {
          return Right(token);
        }
        return Left(UnhandledFailure('Token não encontrado na resposta'));
      }
      return Left(UnhandledFailure('Formato de resposta inválido'));
    } on AppFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure('Erro inesperado: ${e.toString()}'));
    }
  }
}
