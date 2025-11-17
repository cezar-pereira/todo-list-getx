import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/core.dart';
import '../../domain/entities/todo_entity.dart';
import '../presentation.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final controller = Get.find<TodoController>();
  final networkStatusService = Get.find<NetworkStatusService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
        actions: [
          ListenableBuilder(
            listenable: networkStatusService,
            builder: (context, _) {
              return networkStatusService.isOffline
                  ? const Padding(
                      key: TodoListKeys.offlineIcon,
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.cloud_off, color: Colors.orange),
                    )
                  : const Padding(
                      key: TodoListKeys.onlineIcon,
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.cloud_done, color: Colors.green),
                    );
            },
          ),
          IconButton(
            key: TodoListKeys.refreshButton,
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadTodos,
            tooltip: 'Atualizar lista',
          ),
        ],
      ),
      body: controller.obx(
        (todos) => _TodoListPageSuccess(todos: todos ?? []),
        onLoading: const _TodoListPageLoading(),
        onError: (error) =>
            _TodoListPageError(error: error, onRetry: controller.loadTodos),
        onEmpty: const _TodoListPageEmpty(),
      ),
    );
  }
}

class _TodoListPageLoading extends StatelessWidget {
  const _TodoListPageLoading();

  @override
  Widget build(BuildContext context) {
    return const Center(
      key: TodoListKeys.loading,
      child: CircularProgressIndicator(),
    );
  }
}

class _TodoListPageError extends StatelessWidget {
  final String? error;
  final VoidCallback onRetry;
  const _TodoListPageError({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: TodoListKeys.error,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            error ?? 'Erro ao carregar tarefas',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            key: TodoListKeys.retryButton,
            onPressed: onRetry,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }
}

class _TodoListPageSuccess extends StatelessWidget {
  final List<TodoEntity> todos;
  const _TodoListPageSuccess({required this.todos});

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const _TodoListPageEmpty();
    }

    return ListView.builder(
      key: TodoListKeys.success,
      itemCount: todos.length,
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: Icon(
              todo.completed
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: todo.completed ? Colors.green : Colors.grey,
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                decoration: todo.completed
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: todo.completed ? Colors.grey : Colors.black,
              ),
            ),
            subtitle: Text(
              'ID: ${todo.id}',
              style: const TextStyle(fontSize: 12),
            ),
            trailing: Chip(
              label: Text(
                todo.completed ? 'Concluída' : 'Pendente',
                style: const TextStyle(fontSize: 12),
              ),
              backgroundColor: todo.completed
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.orange.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }
}

class _TodoListPageEmpty extends StatelessWidget {
  const _TodoListPageEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: TodoListKeys.emptyList,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.task_alt, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            'Nenhuma tarefa encontrada',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
