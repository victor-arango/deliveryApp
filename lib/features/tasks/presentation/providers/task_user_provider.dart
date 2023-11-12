import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';
import 'package:mensaeria_alv/features/tasks/domain/repositories/task_user_repository.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/task_user_rpository_provider.dart';

//Provider

final taskUSerProvider =
    StateNotifierProvider<TaskUserNotifier, TaskUserState>((ref) {
  final tasksUserRepository = ref.watch(taskUserRepositoyProvider);
  final idUser = ref.watch(authProvider).user?.id ?? '';
  final userId = int.parse(idUser);

  return TaskUserNotifier(
      taskUserRepository: tasksUserRepository, userId: userId);
});

//Notifier
class TaskUserNotifier extends StateNotifier<TaskUserState> {
  final TaskUserRepository taskUserRepository;

  TaskUserNotifier({required this.taskUserRepository, required int userId})
      : super(TaskUserState(userId: userId, status: 'ASIGNADO')) {
    loadTask();
  }

  Future loadTask() async {
    if (state.status == 'ASIGNADO' && state.tasksUser.isEmpty) {
      // Cargar tareas asignadas solo si no están cargadas
      final tasks = await taskUserRepository.getTaskByIdAndStatus(
          state.userId, state.status);

      if (tasks.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      state = state.copyWith(
          isLastPage: false,
          isLoading: false,
          tasksUser: [...state.tasksUser, ...tasks]);
    } else if (state.status == 'FINALIZADO' && state.tasksUserFin.isEmpty) {
      // Cargar tareas finalizadas solo si no están cargadas
      final tasks = await taskUserRepository.getTaskByIdAndStatus(
          state.userId, state.status);

      if (tasks.isEmpty) {
        state = state.copyWith(isLoading: false, isLastPage: true);
        return;
      }

      state = state.copyWith(
          isLastPage: false,
          isLoading: false,
          tasksUserFin: [...state.tasksUserFin, ...tasks]);
    }
  }

  void changeTab(String status) {
    state = state.copyWith(status: status);
    loadTask(); // Cargar las tareas solo si no están cargadas
  }

  Future<bool> updateTask(Map<String, dynamic> taskLike) async {
    try {
      final task = await taskUserRepository.updateTask(taskLike);

      if (state.status == 'FINALIZADO') {
        state = state.copyWith(
            tasksUser: state.tasksUser
                .map(
                  (element) => (element.id == task.id) ? task : element,
                )
                .toList());
        return true;
      } else {
        state = state.copyWith(
            tasksUserFin: state.tasksUserFin
                .map(
                  (element) => (element.id == task.id) ? task : element,
                )
                .toList());
        return true;
      }
    } catch (e) {
      return false;
    }
  }
}

// StateNotifier Provider
class TaskUserState {
  final bool isLastPage;
  final bool isLoading;
  final List<TaskUser> tasksUser;
  final List<TaskUser> tasksUserFin;
  final int userId;
  final String status;

  TaskUserState({
    this.isLastPage = false,
    this.isLoading = false,
    this.tasksUser = const [],
    this.tasksUserFin = const [],
    required this.userId,
    this.status = 'FINALIZADO',
  });

  TaskUserState copyWith({
    bool? isLastPage = false,
    bool? isLoading = false,
    List<TaskUser>? tasksUser,
    List<TaskUser>? tasksUserFin,
    int? userId,
    String? status,
  }) =>
      TaskUserState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        tasksUser: tasksUser ?? this.tasksUser,
        tasksUserFin: tasksUserFin ?? this.tasksUserFin,
        userId: userId ?? this.userId,
        status: status ?? this.status,
      );
}
