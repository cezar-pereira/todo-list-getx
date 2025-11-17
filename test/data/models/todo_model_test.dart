import 'package:flutter_test/flutter_test.dart';
import 'package:todolist/data/models/todo_model.dart';

void main() {
  group('TodoModel', () {
    test('deve criar um TodoModel a partir de JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'title': 'Teste',
        'completed': false,
      };

      // Act
      final todo = TodoModel.fromJson(json);

      // Assert
      expect(todo.id, 1);
      expect(todo.title, 'Teste');
      expect(todo.completed, false);
    });

    test('deve converter TodoModel para JSON', () {
      // Arrange
      final todo = TodoModel(
        id: 1,
        title: 'Teste',
        completed: true,
      );

      // Act
      final json = todo.toJson();

      // Assert
      expect(json['id'], 1);
      expect(json['title'], 'Teste');
      expect(json['completed'], true);
    });

    test('deve criar um TodoModel com valores corretos', () {
      // Arrange & Act
      final todo = TodoModel(
        id: 2,
        title: 'Outro teste',
        completed: false,
      );

      // Assert
      expect(todo.id, 2);
      expect(todo.title, 'Outro teste');
      expect(todo.completed, false);
    });
  });
}

