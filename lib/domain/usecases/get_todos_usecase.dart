import 'package:fpdart/fpdart.dart';
import '../../core/core.dart';
import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

abstract class IGetTodosUseCase {
  Future<Either<AppFailure, List<TodoEntity>>> call(String? token);
}

class GetTodosUseCase implements IGetTodosUseCase {
  final TodoRepository repository;
  GetTodosUseCase(this.repository);

  @override
  Future<Either<AppFailure, List<TodoEntity>>> call(String? token) async {
    if (token == null) {
      final cacheResult = await repository.getTodosFromCache();
      return cacheResult.fold(
        (failure) => Left(UnhandledFailure(failure.message)),
        (todos) => Right(todos),
      );
    }

    final remoteResult = await repository.getTodosFromRemote(token);

    return await remoteResult.fold(
      (failure) async {
        if (failure is NoNetworkFailure || failure is ServerFailure) {
          final cacheResult = await repository.getTodosFromCache();
          return cacheResult.fold(
            (cacheFailure) => Left(failure),
            (todos) => Right(todos),
          );
        }
        return Left(failure);
      },
      (todos) async {
        await repository.clearCache();
        final saveResult = await repository.saveTodosToCache(todos);
        return saveResult.fold((failure) {
          //Logs...
          return Right(todos);
        }, (_) => Right(todos));
      },
    );
  }
}
