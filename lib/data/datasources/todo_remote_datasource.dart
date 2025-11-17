import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';
import '../models/todo_model.dart';

abstract class TodoRemoteDataSource {
  Future<Either<AppFailure, List<TodoModel>>> getTodos(String token);
}

class TodoRemoteDataSourceImpl implements TodoRemoteDataSource {
  final RestClient restClient;

  TodoRemoteDataSourceImpl({required this.restClient});

  @override
  Future<Either<AppFailure, List<TodoModel>>> getTodos(String token) async {
    try {
      final response = await restClient.get<List<dynamic>>(
        'todos',
        token: token,
      );

      if (response.data != null) {
        final todos = (response.data as List)
            .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
            .toList();
        return Right(todos);
      }
      return Left(UnhandledFailure('Resposta vazia do servidor'));
    } on AppFailure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(UnhandledFailure('Erro inesperado: ${e.toString()}'));
    }
  }
}
