import 'package:fpdart/fpdart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todolist/core/errors/failures.dart';
import 'package:todolist/data/models/todo_model.dart';
import 'package:todolist/domain/repositories/todo_repository.dart';
import 'package:todolist/domain/usecases/get_todos_usecase.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late GetTodosUseCase useCase;
  late MockTodoRepository mockRepository;

  setUp(() {
    mockRepository = MockTodoRepository();
    useCase = GetTodosUseCase(mockRepository);
  });

  group('GetTodosUseCase', () {
    final todos = [
      TodoModel(id: 1, title: 'Tarefa 1', completed: false),
      TodoModel(id: 2, title: 'Tarefa 2', completed: true),
    ];

    test('deve buscar do cache quando token é null', () async {
      // Arrange
      when(
        () => mockRepository.getTodosFromCache(),
      ).thenAnswer((_) async => Right(todos));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Não deveria retornar erro'), (todosList) {
        expect(todosList.length, 2);
        expect(todosList[0].id, 1);
        expect(todosList[1].id, 2);
      });
      verify(() => mockRepository.getTodosFromCache()).called(1);
      verifyNever(() => mockRepository.getTodosFromRemote(any()));
    });

    test(
      'deve buscar da API quando token não é null e retornar sucesso',
      () async {
        // Arrange
        const token = 'valid_token';

        when(
          () => mockRepository.getTodosFromRemote(token),
        ).thenAnswer((_) async => Right(todos));
        when(
          () => mockRepository.clearCache(),
        ).thenAnswer((_) async => const Right(null));
        when(
          () => mockRepository.saveTodosToCache(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(token);

        // Assert
        expect(result.isRight(), true);
        result.fold((failure) => fail('Não deveria retornar erro'), (
          todosList,
        ) {
          expect(todosList.length, 2);
          expect(todosList[0].id, 1);
          expect(todosList[1].id, 2);
        });
        verify(() => mockRepository.getTodosFromRemote(token)).called(1);
        verify(() => mockRepository.clearCache()).called(1);
        verify(() => mockRepository.saveTodosToCache(any())).called(1);
        verifyNever(() => mockRepository.getTodosFromCache());
      },
    );

    test('deve buscar do cache quando API retorna NoNetworkFailure', () async {
      // Arrange
      const token = 'valid_token';
      final noNetworkFailure = NoNetworkFailure();

      when(
        () => mockRepository.getTodosFromRemote(token),
      ).thenAnswer((_) async => Left(noNetworkFailure));
      when(
        () => mockRepository.getTodosFromCache(),
      ).thenAnswer((_) async => Right(todos));

      // Act
      final result = await useCase(token);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Não deveria retornar erro, deveria buscar do cache'),
        (todosList) {
          expect(todosList.length, 2);
          expect(todosList[0].id, 1);
          expect(todosList[1].id, 2);
        },
      );
      verify(() => mockRepository.getTodosFromRemote(token)).called(1);
      verify(() => mockRepository.getTodosFromCache()).called(1);
      verifyNever(() => mockRepository.clearCache());
      verifyNever(() => mockRepository.saveTodosToCache(any()));
    });

    test('deve buscar do cache quando API retorna ServerFailure', () async {
      // Arrange
      const token = 'valid_token';
      final serverFailure = ServerFailure();

      when(
        () => mockRepository.getTodosFromRemote(token),
      ).thenAnswer((_) async => Left(serverFailure));
      when(
        () => mockRepository.getTodosFromCache(),
      ).thenAnswer((_) async => Right(todos));

      // Act
      final result = await useCase(token);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (failure) => fail('Não deveria retornar erro, deveria buscar do cache'),
        (todosList) {
          expect(todosList.length, 2);
          expect(todosList[0].id, 1);
          expect(todosList[1].id, 2);
        },
      );
      verify(() => mockRepository.getTodosFromRemote(token)).called(1);
      verify(() => mockRepository.getTodosFromCache()).called(1);
      verifyNever(() => mockRepository.clearCache());
      verifyNever(() => mockRepository.saveTodosToCache(any()));
    });

    test(
      'deve retornar erro quando API retorna NoNetworkFailure e cache também falha',
      () async {
        // Arrange
        const token = 'valid_token';
        final noNetworkFailure = NoNetworkFailure();
        final cacheFailure = CacheFailure();

        when(
          () => mockRepository.getTodosFromRemote(token),
        ).thenAnswer((_) async => Left(noNetworkFailure));
        when(
          () => mockRepository.getTodosFromCache(),
        ).thenAnswer((_) async => Left(cacheFailure));

        // Act
        final result = await useCase(token);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<NoNetworkFailure>()),
          (todosList) => fail('Deveria retornar erro'),
        );
        verify(() => mockRepository.getTodosFromRemote(token)).called(1);
        verify(() => mockRepository.getTodosFromCache()).called(1);
      },
    );

    test(
      'deve retornar erro quando API retorna UnauthorizedFailure (não busca cache)',
      () async {
        // Arrange
        const token = 'invalid_token';
        final unauthorizedFailure = UnauthorizedFailure();

        when(
          () => mockRepository.getTodosFromRemote(token),
        ).thenAnswer((_) async => Left(unauthorizedFailure));

        // Act
        final result = await useCase(token);

        // Assert
        expect(result.isLeft(), true);
        result.fold(
          (failure) => expect(failure, isA<UnauthorizedFailure>()),
          (todosList) => fail('Deveria retornar erro'),
        );
        verify(() => mockRepository.getTodosFromRemote(token)).called(1);
        verifyNever(() => mockRepository.getTodosFromCache());
      },
    );

    test('deve retornar erro quando cache falha e token é null', () async {
      // Arrange
      final cacheFailure = CacheFailure();

      when(
        () => mockRepository.getTodosFromCache(),
      ).thenAnswer((_) async => Left(cacheFailure));

      // Act
      final result = await useCase(null);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<UnhandledFailure>()),
        (todosList) => fail('Deveria retornar erro'),
      );
      verify(() => mockRepository.getTodosFromCache()).called(1);
      verifyNever(() => mockRepository.getTodosFromRemote(any()));
    });

    test('deve salvar no cache mesmo se clearCache falhar', () async {
      // Arrange
      const token = 'valid_token';
      final cacheFailure = CacheFailure();

      when(
        () => mockRepository.getTodosFromRemote(token),
      ).thenAnswer((_) async => Right(todos));
      when(
        () => mockRepository.clearCache(),
      ).thenAnswer((_) async => Left(cacheFailure));
      when(
        () => mockRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(token);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Não deveria retornar erro'), (todosList) {
        expect(todosList.length, 2);
      });
      verify(() => mockRepository.getTodosFromRemote(token)).called(1);
      verify(() => mockRepository.clearCache()).called(1);
      verify(() => mockRepository.saveTodosToCache(any())).called(1);
    });

    test('deve retornar sucesso mesmo se saveTodosToCache falhar', () async {
      // Arrange
      const token = 'valid_token';
      final cacheFailure = CacheFailure();

      when(
        () => mockRepository.getTodosFromRemote(token),
      ).thenAnswer((_) async => Right(todos));
      when(
        () => mockRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));
      when(
        () => mockRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => Left(cacheFailure));

      // Act
      final result = await useCase(token);

      // Assert
      expect(result.isRight(), true);
      result.fold((failure) => fail('Não deveria retornar erro'), (todosList) {
        expect(todosList.length, 2);
      });
      verify(() => mockRepository.getTodosFromRemote(token)).called(1);
      verify(() => mockRepository.clearCache()).called(1);
      verify(() => mockRepository.saveTodosToCache(any())).called(1);
    });

    test(
      'deve retornar lista vazia quando cache está vazio e token é null',
      () async {
        // Arrange
        when(
          () => mockRepository.getTodosFromCache(),
        ).thenAnswer((_) async => const Right([]));

        // Act
        final result = await useCase(null);

        // Assert
        expect(result.isRight(), true);
        result.fold(
          (failure) => fail('Não deveria retornar erro'),
          (todosList) => expect(todosList.isEmpty, true),
        );
        verify(() => mockRepository.getTodosFromCache()).called(1);
      },
    );
  });
}
