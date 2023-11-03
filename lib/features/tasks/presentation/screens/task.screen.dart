import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/task_provider.dart';

class TaskScreen extends ConsumerWidget {
  final String taskId;
  const TaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewProvider(taskId));
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Editar tarea')),
      ),
      body: Center(
        child: Text(taskState.task?.descripcion ?? 'Cargando'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}
