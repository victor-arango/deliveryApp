import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:mensaeria_alv/features/auth/presentation/providers/auth_provider.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/inputs/inputs.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/providers.dart';

//PROVIDER

final formTaskProvider = StateNotifierProvider.autoDispose
    .family<FormTaskNotifier, FormTaskState, TaskUser>((ref, task) {
  final updateCallback =
      ref.watch(taskUSerProvider.notifier).createOrUpdateProduct;
  final userState = ref.watch(authProvider);

  return FormTaskNotifier(
      task: task, onSubmitCallback: updateCallback, userState);
});

class FormTaskNotifier extends StateNotifier<FormTaskState> {
  final AuthState userState;
  final Future<bool> Function(Map<String, dynamic> taskLike)? onSubmitCallback;

  FormTaskNotifier(
    this.userState, {
    this.onSubmitCallback,
    required TaskUser task,
  }) : super(FormTaskState(
            id: task.id,
            description: Description.dirty(task.descripcion),
            timestamp: DropdowDate.dirty(task.timestamp),
            deliveryId: Dropdow.dirty(int.parse(task.deliveryId)),
            priority: DropdowPriority.dirty(task.priority)));

  Future<bool> onFormSubmit() async {
    _touchedEveryThing();

    if (!state.isFormvValid) return false;

    if (onSubmitCallback == null) return false;

    final taskLike = {
      'id': (state.id == 'new') ? null : state.id,
      'user_id': userState.user?.id,
      'descripcion': state.description.value,
      'timestamp': state.timestamp.value,
      'delivery_id': state.deliveryId.value,
      'priority': state.priority.value,
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
        Description.dirty(state.description.value),
        DropdowDate.dirty(state.timestamp.value),
        Dropdow.dirty(state.deliveryId.value),
        DropdowPriority.dirty(state.priority.value),
      ]),
    );
  }

  void onDescriptionChanged(String value) {
    state = state.copyWith(
        description: Description.dirty(value),
        isFormvValid: Formz.validate([
          Description.dirty(value),
          DropdowDate.dirty(state.timestamp.value),
          Dropdow.dirty(state.deliveryId.value),
          DropdowPriority.dirty(state.priority.value)
        ]));
  }

  void onDropDateChanged(String value) {
    state = state.copyWith(
        timestamp: DropdowDate.dirty(value),
        isFormvValid: Formz.validate([
          Description.dirty(state.description.value),
          DropdowDate.dirty(value),
          Dropdow.dirty(state.deliveryId.value),
          DropdowPriority.dirty(state.priority.value)
        ]));
  }

  void onDropdownChanged(int value) {
    state = state.copyWith(
        deliveryId: Dropdow.dirty(value),
        isFormvValid: Formz.validate([
          Description.dirty(state.description.value),
          DropdowDate.dirty(state.timestamp.value),
          Dropdow.dirty(value),
          DropdowPriority.dirty(state.priority.value)
        ]));
  }

  void onDropdownPriorityChanged(String value) {
    state = state.copyWith(
        priority: DropdowPriority.dirty(value),
        isFormvValid: Formz.validate([
          Description.dirty(state.description.value),
          DropdowDate.dirty(state.timestamp.value),
          Dropdow.dirty(state.deliveryId.value),
          DropdowPriority.dirty(value)
        ]));
  }
}

//STATE

class FormTaskState {
  final bool isFormvValid;
  final String? id;
  final Description description;
  final DropdowDate timestamp;
  final Dropdow deliveryId;
  final DropdowPriority priority;

  FormTaskState(
      {this.isFormvValid = false,
      this.id,
      this.description = const Description.dirty(''),
      this.timestamp = const DropdowDate.dirty(''),
      this.deliveryId = const Dropdow.dirty(0),
      this.priority = const DropdowPriority.dirty('')});

  FormTaskState copyWith({
    bool? isFormvValid,
    String? id,
    Description? description,
    DropdowDate? timestamp,
    Dropdow? deliveryId,
    DropdowPriority? priority,
  }) =>
      FormTaskState(
          isFormvValid: isFormvValid ?? this.isFormvValid,
          id: id ?? this.id,
          description: description ?? this.description,
          timestamp: timestamp ?? this.timestamp,
          deliveryId: deliveryId ?? this.deliveryId,
          priority: priority ?? this.priority);
}
