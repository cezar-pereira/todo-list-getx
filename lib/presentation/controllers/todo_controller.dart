import 'package:get/get.dart';

import '../../core/core.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_todos_usecase.dart';

class TodoController extends GetxController with StateMixin<List<TodoEntity>> {
  final IGetTodosUseCase getTodosUseCase;
  final AuthRepository authRepository;
  final NetworkStatusService networkStatusService;
  final TokenService tokenService;

  TodoController({
    required this.getTodosUseCase,
    required this.authRepository,
    required this.networkStatusService,
    required this.tokenService,
  });

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    change([], status: RxStatus.loading());

    final hasToken = await tokenService.hasToken();
    String? token;

    if (!hasToken) {
      final authResult = await authRepository.authenticate(
        login: AppConfig.authLogin,
        password: AppConfig.authPassword,
      );

      token = authResult.fold((failure) {
        change([], status: RxStatus.error(failure.messageError));
        return null;
      }, (authToken) => authToken);

      if (token == null) return;
    } else {
      token = await tokenService.getToken();
    }

    final result = await getTodosUseCase(token);
    result.fold(
      (failure) {
        change([], status: RxStatus.error(failure.messageError));
      },
      (todosList) {
        if (todosList.isEmpty) {
          change([], status: RxStatus.empty());
        } else {
          change(todosList, status: RxStatus.success());
        }
      },
    );
  }
}
