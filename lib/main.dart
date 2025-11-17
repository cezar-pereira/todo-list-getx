import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_module.dart';
import 'presentation/pages/todo_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialBinding: AppModule(),
      home: const TodoListPage(),
    );
  }
}
