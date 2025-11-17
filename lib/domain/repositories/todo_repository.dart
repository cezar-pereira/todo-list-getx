import 'package:fpdart/fpdart.dart';

import '../../core/core.dart';
import '../entities/todo_entity.dart';

abstract class TodoRepository {
  Future<Either<AppFailure, List<TodoEntity>>> getTodosFromRemote(String token);
  Future<Either<CacheFailure, List<TodoEntity>>> getTodosFromCache();
  Future<Either<CacheFailure, void>> saveTodosToCache(List<TodoEntity> todos);
  Future<Either<CacheFailure, void>> clearCache();
}
