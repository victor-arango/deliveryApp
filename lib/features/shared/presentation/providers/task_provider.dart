import 'package:build_context_provider/build_context_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/auth/infrastructure/infrasctuture.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/infrastructure.dart';

import '../../domain/domain.dart';

final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>((ref) {
  final taskRespository = CreateTaskRepositoryImpl();

  return TaskNotifier(taskRepository: taskRespository);
});

class TaskNotifier extends StateNotifier<TaskState> {
  final CreateTaskRepository taskRepository;
  TaskNotifier({required this.taskRepository}) : super(TaskState());

  Future<void> createTask(int userId, String descripcion, int deliveryId,
      String priority, String timestamp) async {
    try {
      final task = await taskRepository.createTask(
          userId, descripcion, deliveryId, priority, timestamp);
      _redirect();
      _setCreateTask(task);
    } on CustomError catch (e) {
      errorMessage(e.message);
    } catch (e) {
      errorMessage('Error no controlado');
    }
  }

  //demas metodos necesarios

  void _redirect() {
    BuildContextProvider()((context) {
      context.pop();
    });
  }

  _setCreateTask(Task task) {
    state = state.copyWith(
      task: task,
      taskStatus: TaskStatus.insert,
    );
  }

  Future<void> errorMessage(String? errorMessage) async {
    state = state.copyWith(
      taskStatus: TaskStatus.notInsert,
      task: null,
      errorMessage: errorMessage,
    );
  }
}

enum TaskStatus { checking, insert, notInsert }

class TaskState {
  final TaskStatus taskStatus;
  final Task? task;
  final String errorMessage;

  TaskState(
      {this.taskStatus = TaskStatus.checking,
      this.task,
      this.errorMessage = ''});

  TaskState copyWith({
    TaskStatus? taskStatus,
    Task? task,
    String? errorMessage,
  }) =>
      TaskState(
          taskStatus: taskStatus ?? this.taskStatus,
          task: task ?? this.task,
          errorMessage: errorMessage ?? this.errorMessage);
}
