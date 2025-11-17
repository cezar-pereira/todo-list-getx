import 'package:fpdart/fpdart.dart';

import '../../core/core.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/todo_local_datasource.dart';
import '../datasources/todo_remote_datasource.dart';
import '../models/todo_model.dart';

class TodoRepositoryImpl implements TodoRepository {
  final TodoRemoteDataSource remoteDataSource;
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<AppFailure, List<TodoEntity>>> getTodosFromRemote(
    String token,
  ) async {
    final remoteResult = await remoteDataSource.getTodos(token);
    return remoteResult.fold(
      (failure) => Left(failure),
      (todos) => Right(todos),
    );
  }

  @override
  Future<Either<CacheFailure, List<TodoEntity>>> getTodosFromCache() async {
    final result = await localDataSource.getTodos();
    return result.fold((failure) => Left(failure), (todos) => Right(todos));
  }

  @override
  Future<Either<CacheFailure, void>> saveTodosToCache(
    List<TodoEntity> todos,
  ) async {
    final todoModels = todos
        .map(
          (todo) => todo is TodoModel
              ? todo
              : TodoModel(
                  id: todo.id,
                  title: todo.title,
                  completed: todo.completed,
                ),
        )
        .toList();
    return await localDataSource.saveTodos(todoModels);
  }

  @override
  Future<Either<CacheFailure, void>> clearCache() async {
    return await localDataSource.clearTodos();
  }
}
