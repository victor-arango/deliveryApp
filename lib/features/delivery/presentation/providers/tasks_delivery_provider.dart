//STATE

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/delivery/domain/domain.dart';
import 'package:mensaeria_alv/features/delivery/presentation/providers/task_delivery_repository.dart';

//STATE NOTIFIER

final taskDeliverysProvider =
    StateNotifierProvider.autoDispose<TaskDeliveryNotifier, TaskDeliveryState>(
        (ref) {
  final taskDeliveryRepository = ref.watch(taskDeliveryRespositoryProvider);
  final idUser = ref.watch(authProvider).user?.id ?? '';
  return TaskDeliveryNotifier(
      taskDeliveryRepository: taskDeliveryRepository, userId: idUser);
});

//NOTIFIER

class TaskDeliveryNotifier extends StateNotifier<TaskDeliveryState> {
  final TaskDeliveryRepository taskDeliveryRepository;

  TaskDeliveryNotifier(
      {required this.taskDeliveryRepository, required String userId})
      : super(TaskDeliveryState(userId: userId, status: 'ASIGNADO')) {
    loadTasks();
  }

  Future loadTasks() async {
    if (state.isLoading || state.isLoadTask) return;

    state = state.copyWith(isLoading: true);

    final tasks = await taskDeliveryRepository.getTaskByIdAndStatus(
        state.userId, state.status);

    if (tasks.isEmpty) {
      state = state.copyWith(isLoading: false, isLoadTask: true);
      return;
    }

    state = state.copyWith(
        isLoadTask: false, isLoading: false, tasks: [...state.tasks, ...tasks]);
  }
}

// STATE
class TaskDeliveryState {
  final bool isLoadTask;
  final bool isLoading;
  final List<TaskDelivery> tasks;
  final String userId;
  final String status;

  TaskDeliveryState(
      {this.isLoadTask = false,
      this.isLoading = false,
      this.tasks = const [],
      required this.userId,
      this.status = 'ASIGNADO'});

  TaskDeliveryState copyWith({
    bool? isLoadTask,
    bool? isLoading,
    List<TaskDelivery>? tasks,
    String? userId,
    String? status,
  }) =>
      TaskDeliveryState(
        isLoadTask: isLoadTask ?? this.isLoadTask,
        isLoading: isLoadTask ?? this.isLoading,
        tasks: tasks ?? this.tasks,
        userId: userId ?? this.userId,
        status: status ?? this.status,
      );
}
