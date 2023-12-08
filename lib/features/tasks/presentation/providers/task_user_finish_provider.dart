import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';
import 'package:mensaeria_alv/features/tasks/domain/repositories/task_user_repository.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/task_user_rpository_provider.dart';

//Provider

final taskUSerFinishProvider =
    StateNotifierProvider<TaskUserNotifier, TaskUserState>((ref) {
  final tasksUserRepository = ref.watch(taskUserRepositoyProvider);
  final idUser = ref.watch(authProvider).user?.id ?? '';
  final userId = idUser;

  return TaskUserNotifier(
      taskUserRepository: tasksUserRepository, userId: userId);
});

//Notifier
class TaskUserNotifier extends StateNotifier<TaskUserState> {
  final TaskUserRepository taskUserRepository;

  TaskUserNotifier({required this.taskUserRepository, required String userId})
      : super(TaskUserState(userId: userId, status: 'FINALIZADO')) {
    loadTask();
  }

  // Future<bool> createOrUpdateProduct(Map<String, dynamic> taskLike) async {
  //   try {
  //     final task = await taskUserRepository.updateTask(taskLike);
  //     final isTaskInList =
  //         state.tasksUserFin.any((element) => element.id == task.id);

  //     if (!isTaskInList) {
  //       state = state.copyWith(tasksUserFin: [...state.tasksUserFin, task]);
  //       return true;
  //     }

  //     state = state.copyWith(
  //         tasksUserFin: state.tasksUserFin
  //             .map(
  //               (element) => (element.id == task.id) ? task : element,
  //             )
  //             .toList());
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future loadTask() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

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

  Future<bool> deleteTask(Map<String, dynamic> taskLike) async {
    try {
      final task = await taskUserRepository.updateRatingTask(taskLike);

      state = state.copyWith(
        tasksUserFin: state.tasksUserFin
            .where((element) => element.id != task.id)
            .toList(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }
}

// StateNotifier Provider
class TaskUserState {
  final bool isLastPage;
  final bool isLoading;
  final List<TaskUser> tasksUserFin;
  final String userId;
  final String status;

  TaskUserState({
    this.isLastPage = false,
    this.isLoading = false,
    this.tasksUserFin = const [],
    required this.userId,
    this.status = 'FINALIZADO',
  });

  TaskUserState copyWith({
    bool? isLastPage = false,
    bool? isLoading = false,
    List<TaskUser>? tasksUserFin,
    String? userId,
    String? status,
  }) =>
      TaskUserState(
        isLastPage: isLastPage ?? this.isLastPage,
        isLoading: isLoading ?? this.isLoading,
        tasksUserFin: tasksUserFin ?? this.tasksUserFin,
        userId: userId ?? this.userId,
        status: status ?? this.status,
      );
}
