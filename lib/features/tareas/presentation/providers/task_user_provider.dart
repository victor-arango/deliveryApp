import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/tareas/domain/entities/task_user.dart';
import 'package:mensaeria_alv/features/tareas/domain/repositories/task_user_repository.dart';
import 'package:mensaeria_alv/features/tareas/presentation/providers/task_user_rpository_provider.dart';

//Provider

final taskUSerProvider =
    StateNotifierProvider<TaskUserNotifier, TaskUserState>((ref) {
  final tasksUserRepository = ref.watch(taskUserRepositoyProvider);

  return TaskUserNotifier(taskUserRepository: tasksUserRepository);
});

//Notifier

class TaskUserNotifier extends StateNotifier<TaskUserState> {
  final TaskUserRepository taskUserRepository;

  TaskUserNotifier({required this.taskUserRepository})
      : super(TaskUserState()) {
    loadTask();
  }

  Future loadTask() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final tasks = await taskUserRepository.getTaskByIdAndStatus(
        state.idUser, state.status);

    if (tasks.isEmpty) {
      state = state.copyWith(isLoading: false, isLastPage: true);
      return;
    }

    state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        tasksUser: [...state.tasksUser, ...tasks]);
  }
}

// StateNotifier Provider
class TaskUserState {
  final bool isLastPage;
  final bool isLoading;
  final List<TaskUser> tasksUser;
  final int idUser;
  final String status;

  TaskUserState({
    this.isLastPage = false,
    this.isLoading = false,
    this.tasksUser = const [],
    this.idUser = 9,
    this.status = 'ASIGNADO',
  });

  TaskUserState copyWith({
    bool? isLastPage = false,
    bool? isLoading = false,
    List<TaskUser>? tasksUser,
    int? idUser,
    String? status,
  }) =>
      TaskUserState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        tasksUser: tasksUser ?? this.tasksUser,
        idUser: idUser ?? this.idUser,
        status: status ?? this.status,
      );
}
