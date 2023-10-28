import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/tareas/domain/entities/task_user.dart';
import 'package:mensaeria_alv/features/tareas/domain/repositories/task_user_repository.dart';
import 'package:mensaeria_alv/features/tareas/presentation/providers/task_user_rpository_provider.dart';

//Provider

final taskUSerProvider =
    StateNotifierProvider.autoDispose<TaskUserNotifier, TaskUserState>((ref) {
  final tasksUserRepository = ref.watch(taskUserRepositoyProvider);

  return TaskUserNotifier(taskUserRepository: tasksUserRepository);
});

//Notifier
class TaskUserNotifier extends StateNotifier<TaskUserState> {
  final TaskUserRepository taskUserRepository;

  TaskUserNotifier({required this.taskUserRepository})
      : super(TaskUserState(status: 'ASIGNADO')) {
    loadTask();
  }

  Future loadTask() async {
    if (state.status == 'ASIGNADO' && state.tasksUser.isEmpty) {
      // Cargar tareas asignadas solo si no están cargadas
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
    } else if (state.status == 'FINALIZADO' && state.tasksUserFin.isEmpty) {
      // Cargar tareas finalizadas solo si no están cargadas
      final tasks = await taskUserRepository.getTaskByIdAndStatus(
          state.idUser, state.status);

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
}

// StateNotifier Provider
class TaskUserState {
  final bool isLastPage;
  final bool isLoading;
  final List<TaskUser> tasksUser;
  final List<TaskUser> tasksUserFin;
  final int idUser;
  final String status;

  TaskUserState({
    this.isLastPage = false,
    this.isLoading = false,
    this.tasksUser = const [],
    this.tasksUserFin = const [],
    this.idUser = 1,
    this.status = 'FINALIZADO',
  });

  TaskUserState copyWith({
    bool? isLastPage = false,
    bool? isLoading = false,
    List<TaskUser>? tasksUser,
    List<TaskUser>? tasksUserFin,
    int? idUser,
    String? status,
  }) =>
      TaskUserState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        tasksUser: tasksUser ?? this.tasksUser,
        tasksUserFin: tasksUserFin ?? this.tasksUserFin,
        idUser: idUser ?? this.idUser,
        status: status ?? this.status,
      );
}
