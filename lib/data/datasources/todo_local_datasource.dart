import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../core/core.dart';
import '../models/todo_model.dart';

abstract class TodoLocalDataSource {
  Future<Either<CacheFailure, List<TodoModel>>> getTodos();
  Future<Either<CacheFailure, void>> saveTodos(List<TodoModel> todos);
  Future<Either<CacheFailure, void>> clearTodos();
}

class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final StorageService storageService;

  TodoLocalDataSourceImpl(this.storageService);

  @override
  Future<Either<CacheFailure, List<TodoModel>>> getTodos() async {
    try {
      final jsonString = await storageService.getString(
        StorageService.todosCacheKey,
      );
      if (jsonString == null) {
        return const Right([]);
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      final todos = jsonList
          .map((json) => TodoModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return Right(todos);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<CacheFailure, void>> saveTodos(List<TodoModel> todos) async {
    try {
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await storageService.setString(StorageService.todosCacheKey, jsonString);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<CacheFailure, void>> clearTodos() async {
    try {
      await storageService.remove(StorageService.todosCacheKey);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure());
    }
  }
}
