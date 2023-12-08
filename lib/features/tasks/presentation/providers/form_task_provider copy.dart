import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/inputs/inputs.dart';
import 'package:mensaeria_alv/features/tasks/domain/entities/task_user.dart';

import 'task_user_finish_provider.dart';

//PROVIDER

final formTaskFinishProvider = StateNotifierProvider.autoDispose
    .family<FormTaskNotifier, FormTaskState, TaskUser>((ref, task) {
  final updateCallback = ref.watch(taskUSerFinishProvider.notifier).deleteTask;

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
            rating: Rating.dirty(int.parse(task.ratings!.rating.toString()))));

  Future<bool> onFormSubmit() async {
    _touchedEveryThing();

    if (!state.isFormvValid) return false;

    if (onSubmitCallback == null) return false;

    final taskLike = {
      'id': (state.id == 'new') ? null : state.id,
      'userId': state.userId,
      'deliveryId': state.deliveryId,
      'descripcion': state.descripcion,
      'status': state.status,
      'timestamp': state.timestamp,
      'priority': state.priority,
      'ratings': {
        'taskId': state.id,
        'deliveryId': state.deliveryId,
        'rating': state.rating.value,
      }
    };

    try {
      return await onSubmitCallback!(taskLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEveryThing() {
    state = state.copyWith(
      isFormvValid: Formz.validate([
        Rating.dirty(state.rating.value),
      ]),
    );
  }

  void onRatingChange(int value) {
    state = state.copyWith(
        rating: Rating.dirty(value),
        isFormvValid: Formz.validate([
          Rating.dirty(value),
        ]));
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
  final Rating rating;

  FormTaskState({
    this.isFormvValid = false,
    this.id,
    this.userId,
    this.deliveryId,
    this.descripcion,
    this.status,
    this.timestamp,
    this.priority,
    this.rating = const Rating.dirty(0),
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
    Rating? rating,
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
        rating: rating ?? this.rating,
      );
}
