import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:todolist/core/core.dart';
import 'package:todolist/data/data.dart';
import 'package:todolist/domain/domain.dart';
import 'package:todolist/presentation/presentation.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockTokenService extends Mock implements TokenService {}

class MockNetworkStatusService extends NetworkStatusService {
  bool _isOffline = false;

  @override
  bool get isOffline => _isOffline;

  @override
  bool get isOnline => !_isOffline;

  void setOfflineForTest(bool value) {
    _isOffline = value;
    notifyListeners();
  }
}

void main() {
  late MockTodoRepository mockTodoRepository;
  late MockAuthRepository mockAuthRepository;
  late MockTokenService mockTokenService;
  late MockNetworkStatusService mockNetworkStatusService;
  late GetTodosUseCase getTodosUseCase;
  late TodoController todoController;

  setUp(() {
    mockTodoRepository = MockTodoRepository();
    mockAuthRepository = MockAuthRepository();
    mockTokenService = MockTokenService();
    mockNetworkStatusService = MockNetworkStatusService();
    getTodosUseCase = GetTodosUseCase(mockTodoRepository);
    todoController = TodoController(
      getTodosUseCase: getTodosUseCase,
      authRepository: mockAuthRepository,
      networkStatusService: mockNetworkStatusService,
      tokenService: mockTokenService,
    );
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  group('TodoListPage Widget Tests', () {
    testWidgets('deve exibir erro quando o estado é error', (tester) async {
      // Arrange
      const errorMessage = 'Erro ao carregar tarefas';
      final failure = UnhandledFailure(errorMessage);

      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => Left(failure));

      when(
        () => mockTodoRepository.getTodosFromCache(),
      ).thenAnswer((_) async => Left(CacheFailure()));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      // Aguardar o carregamento assíncrono
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(TodoListKeys.error), findsOneWidget);
      expect(find.byKey(TodoListKeys.retryButton), findsOneWidget);
      expect(find.text(errorMessage), findsOneWidget);
    });

    testWidgets('deve exibir empty quando não há tarefas', (tester) async {
      // Arrange
      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => const Right([]));

      when(
        () => mockTodoRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => mockTodoRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      // Aguardar o carregamento assíncrono
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(TodoListKeys.emptyList), findsOneWidget);
    });

    testWidgets('deve exibir lista de tarefas quando há tarefas', (
      tester,
    ) async {
      // Arrange
      final todos = [
        TodoModel(id: 1, title: 'Tarefa 1', completed: false),
        TodoModel(id: 2, title: 'Tarefa 2', completed: true),
        TodoModel(id: 3, title: 'Tarefa 3', completed: false),
      ];

      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => Right(todos));

      when(
        () => mockTodoRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => mockTodoRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      // Aguardar o carregamento assíncrono
      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(TodoListKeys.success), findsOneWidget);
      expect(find.text(todos[0].title), findsOneWidget);
      expect(find.text(todos[1].title), findsOneWidget);
      expect(find.text(todos[2].title), findsOneWidget);
    });

    testWidgets(
      'deve exibir ícone de offline quando NetworkStatusService.isOffline é true',
      (tester) async {
        // Arrange
        when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.authenticate(
            login: any(named: 'login'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right('token'));

        when(
          () => mockTodoRepository.getTodosFromRemote(any()),
        ).thenAnswer((_) async => const Right([]));

        when(
          () => mockTodoRepository.clearCache(),
        ).thenAnswer((_) async => const Right(null));

        when(
          () => mockTodoRepository.saveTodosToCache(any()),
        ).thenAnswer((_) async => const Right(null));

        mockNetworkStatusService.setOfflineForTest(true);

        Get.put<TodoController>(todoController);
        Get.put<NetworkStatusService>(mockNetworkStatusService);

        // Act
        await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(TodoListKeys.offlineIcon), findsOneWidget);
        expect(find.byKey(TodoListKeys.onlineIcon), findsNothing);
      },
    );

    testWidgets(
      'deve exibir ícone de online quando NetworkStatusService.isOffline é false',
      (tester) async {
        // Arrange
        when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.authenticate(
            login: any(named: 'login'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right('token'));

        when(
          () => mockTodoRepository.getTodosFromRemote(any()),
        ).thenAnswer((_) async => const Right([]));

        when(
          () => mockTodoRepository.clearCache(),
        ).thenAnswer((_) async => const Right(null));

        when(
          () => mockTodoRepository.saveTodosToCache(any()),
        ).thenAnswer((_) async => const Right(null));

        mockNetworkStatusService.setOfflineForTest(false);

        Get.put<TodoController>(todoController);
        Get.put<NetworkStatusService>(mockNetworkStatusService);

        // Act
        await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

        await tester.pumpAndSettle();

        // Assert
        expect(find.byKey(TodoListKeys.onlineIcon), findsOneWidget);
        expect(find.byKey(TodoListKeys.offlineIcon), findsNothing);
      },
    );

    testWidgets('deve exibir tarefas concluídas com estilo correto', (
      tester,
    ) async {
      // Arrange
      final todos = [
        TodoModel(id: 1, title: 'Tarefa Concluída', completed: true),
      ];

      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => Right(todos));

      when(
        () => mockTodoRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => mockTodoRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(TodoListKeys.success), findsOneWidget);
      final textWidget = tester.widget<Text>(find.text('Tarefa Concluída'));
      expect(textWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('deve exibir tarefas pendentes com estilo correto', (
      tester,
    ) async {
      // Arrange
      final todos = [
        TodoModel(id: 1, title: 'Tarefa Pendente', completed: false),
      ];

      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => Right(todos));

      when(
        () => mockTodoRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => mockTodoRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      await tester.pumpAndSettle();

      // Assert
      expect(find.byKey(TodoListKeys.success), findsOneWidget);
      final textWidget = tester.widget<Text>(find.text('Tarefa Pendente'));
      expect(textWidget.style?.decoration, TextDecoration.none);
    });

    testWidgets('deve chamar loadTodos quando botão de refresh é pressionado', (
      tester,
    ) async {
      // Arrange
      when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
      when(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => const Right('token'));

      when(
        () => mockTodoRepository.getTodosFromRemote(any()),
      ).thenAnswer((_) async => const Right([]));

      when(
        () => mockTodoRepository.clearCache(),
      ).thenAnswer((_) async => const Right(null));

      when(
        () => mockTodoRepository.saveTodosToCache(any()),
      ).thenAnswer((_) async => const Right(null));

      Get.put<TodoController>(todoController);
      Get.put<NetworkStatusService>(mockNetworkStatusService);

      // Act
      await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

      await tester.pumpAndSettle();

      // Limpar chamadas anteriores
      clearInteractions(mockAuthRepository);
      clearInteractions(mockTodoRepository);

      await tester.tap(find.byKey(TodoListKeys.refreshButton));
      await tester.pumpAndSettle();

      // Assert
      verify(
        () => mockAuthRepository.authenticate(
          login: any(named: 'login'),
          password: any(named: 'password'),
        ),
      ).called(1);
    });

    testWidgets(
      'deve chamar loadTodos quando botão "Tentar novamente" é pressionado',
      (tester) async {
        // Arrange
        const errorMessage = 'Erro ao carregar tarefas';
        final failure = UnhandledFailure(errorMessage);

        when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.authenticate(
            login: any(named: 'login'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right('token'));

        when(
          () => mockTodoRepository.getTodosFromRemote(any()),
        ).thenAnswer((_) async => Left(failure));

        when(
          () => mockTodoRepository.getTodosFromCache(),
        ).thenAnswer((_) async => Left(CacheFailure()));

        Get.put<TodoController>(todoController);
        Get.put<NetworkStatusService>(mockNetworkStatusService);

        // Act
        await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

        await tester.pumpAndSettle();

        // Limpar chamadas anteriores
        clearInteractions(mockAuthRepository);
        clearInteractions(mockTodoRepository);

        await tester.tap(find.byKey(TodoListKeys.retryButton));
        await tester.pumpAndSettle();

        // Assert
        verify(
          () => mockAuthRepository.authenticate(
            login: any(named: 'login'),
            password: any(named: 'password'),
          ),
        ).called(1);
      },
    );

    testWidgets(
      'deve atualizar ícone quando NetworkStatusService muda de status',
      (tester) async {
        // Arrange
        when(() => mockTokenService.hasToken()).thenAnswer((_) async => false);
        when(
          () => mockAuthRepository.authenticate(
            login: any(named: 'login'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right('token'));

        when(
          () => mockTodoRepository.getTodosFromRemote(any()),
        ).thenAnswer((_) async => const Right([]));

        when(
          () => mockTodoRepository.clearCache(),
        ).thenAnswer((_) async => const Right(null));

        when(
          () => mockTodoRepository.saveTodosToCache(any()),
        ).thenAnswer((_) async => const Right(null));

        mockNetworkStatusService.setOfflineForTest(false);

        Get.put<TodoController>(todoController);
        Get.put<NetworkStatusService>(mockNetworkStatusService);

        // Act
        await tester.pumpWidget(const MaterialApp(home: TodoListPage()));

        await tester.pumpAndSettle();

        // Assert - inicialmente online
        expect(find.byKey(TodoListKeys.onlineIcon), findsOneWidget);
        expect(find.byKey(TodoListKeys.offlineIcon), findsNothing);

        // Simular mudança para offline
        mockNetworkStatusService.setOfflineForTest(true);
        await tester.pumpAndSettle();

        // Assert - agora offline
        expect(find.byKey(TodoListKeys.offlineIcon), findsOneWidget);
        expect(find.byKey(TodoListKeys.onlineIcon), findsNothing);
      },
    );
  });
}
