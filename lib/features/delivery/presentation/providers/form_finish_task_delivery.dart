import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/delivery/presentation/providers/tasks_delivery_provider.dart';
import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';

//PROVIDER

final formTaskDeliveryFinishProvider = StateNotifierProvider.autoDispose
    .family<FormTaskNotifier, FormTaskState, TaskUser>((ref, task) {
  final updateCallback = ref.watch(taskDeliverysProvider.notifier).closeTask;

  return FormTaskNotifier(task: task, onSubmitCallback: updateCallback);
});

class FormTaskNotifier extends StateNotifier<FormTaskState> {
  final Future<bool> Function(Map<String, dynamic> taskLike)? onSubmitCallback;

  FormTaskNotifier({
    this.onSubmitCallback,
    required TaskUser task,
  }) : super(FormTaskState(
          id: task.id,
          userId: task.userId,
          deliveryId: task.deliveryId,
          descripcion: task.descripcion,
          status: task.status,
          timestamp: task.timestamp,
          priority: task.priority,
        ));

  Future<bool> onFormSubmit() async {
    final taskLike = {
      'id': (state.id == 'new') ? null : state.id,
      'userId': state.userId,
      'deliveryId': state.deliveryId,
      'descripcion': state.descripcion,
      'status': state.status,
      'timestamp': state.timestamp,
      'priority': state.priority,
    };

    try {
      return await onSubmitCallback!(taskLike);
    } catch (e) {
      return false;
    }
  }
}

//STATE

class FormTaskState {
  final bool isFormvValid;
  final String? id;
  final String? userId;
  final String? deliveryId;
  final String? descripcion;
  final String? status;
  final String? timestamp;
  final String? priority;

  FormTaskState({
    this.isFormvValid = false,
    this.id,
    this.userId,
    this.deliveryId,
    this.descripcion,
    this.status,
    this.timestamp,
    this.priority,
  });

  FormTaskState copyWith({
    bool? isFormvValid,
    String? id,
    String? userId,
    String? deliveryId,
    String? descripcion,
    String? status,
    String? timestamp,
    String? priority,
  }) =>
      FormTaskState(
        isFormvValid: isFormvValid ?? this.isFormvValid,
        id: id ?? this.id,
        userId: userId ?? this.userId,
        deliveryId: this.deliveryId ?? this.deliveryId,
        descripcion: this.descripcion ?? this.descripcion,
        status: this.status ?? this.status,
        timestamp: this.timestamp ?? this.timestamp,
        priority: this.priority ?? this.priority,
      );
}
