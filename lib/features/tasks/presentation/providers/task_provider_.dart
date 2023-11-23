// ignore_for_file: empty_catches

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';
import 'package:mensaeria_alv/features/tasks/domain/repositories/task_user_repository.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/providers.dart';

//STATE NOTIFIER PROVIDER
final taskViewProvider = StateNotifierProvider.autoDispose
    .family<TaskViewNotifier, TaskViewState, String>((ref, taskId) {
  final taskUserRepository = ref.watch(taskUserRepositoyProvider);

  return TaskViewNotifier(
      taskUserRepository: taskUserRepository, taskId: taskId);
});

//TASK NOTIFIER

class TaskViewNotifier extends StateNotifier<TaskViewState> {
  final TaskUserRepository taskUserRepository;

  TaskViewNotifier({required this.taskUserRepository, required String taskId})
      : super(TaskViewState(id: taskId)) {
    loadTask();
  }

  Future<void> loadTask() async {
    try {
      final task = await taskUserRepository.getTaskById(state.id);
      state = state.copyWith(isLoading: false, task: task);
    } catch (e) {}
  }
}

//ESTADO
class TaskViewState {
  final String id;
  final TaskUser? task;
  final bool isLoading;
  final bool isSaving;

  TaskViewState(
      {required this.id,
      this.task,
      this.isLoading = true,
      this.isSaving = false});

  TaskViewState copyWith(
          {String? id, TaskUser? task, bool? isLoading, bool? isSaving}) =>
      TaskViewState(
          id: id ?? this.id,
          task: task ?? this.task,
          isLoading: isLoading ?? this.isLoading,
          isSaving: isSaving ?? this.isSaving);
}
