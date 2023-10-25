import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:mensaeria_alv/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:mensaeria_alv/features/shared/presentation/providers/task_provider.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';

//! 3 - StateNotifierProvider - consume afuera
final taskFormProvider =
    StateNotifierProvider.autoDispose<TaskFormNotifier, TaskFormState>((ref) {
  final createTaskCallback = ref.watch(taskProvider.notifier).createTask;
  final keyValueStorageService = KeyValueStroageServiceImp();

  return TaskFormNotifier(
      createTaskCallback: createTaskCallback,
      keyValueStorageService: keyValueStorageService);
});

//! 2 - Como implementamos un notifier

class TaskFormNotifier extends StateNotifier<TaskFormState> {
  final Function(int, String, int, String, String) createTaskCallback;
  final KeyValueStorageService keyValueStorageService;

  TaskFormNotifier(
      {required this.createTaskCallback, required this.keyValueStorageService})
      : super(TaskFormState());

  onDescriptionChange(String value) {
    final newDescription = Description.dirty(value);
    state = state.copyWith(
        description: newDescription,
        isValid: Formz.validate([
          newDescription,
          state.dropdown,
          state.dropdowDate,
          state.dropdowPriority,
        ]));
  }

  onDropdownChange(int value) {
    final newDropdown = Dropdow.dirty(value);
    state = state.copyWith(
        dropdown: newDropdown,
        isValid: Formz.validate([
          newDropdown,
          state.description,
          state.dropdowDate,
          state.dropdowPriority,
        ]));
  }

  onDropdownDateChange(String value) {
    final newDropdownDate = DropdowDate.dirty(value);
    state = state.copyWith(
        dropdowDate: newDropdownDate,
        isValid: Formz.validate([
          newDropdownDate,
          state.description,
          state.dropdown,
          state.dropdowPriority,
        ]));
  }

  onDropdownPriorityChange(String value) {
    final newDropdownPriority = DropdowPriority.dirty(value);
    state = state.copyWith(
        dropdowPriority: newDropdownPriority,
        isValid: Formz.validate([
          newDropdownPriority,
          state.description,
          state.dropdown,
          state.dropdowDate,
        ]));
  }

  onFormSubmit() async {
    final idUser = await keyValueStorageService.getValue<String>('idUser');
    _touchEveryField();

    // state = state.copyWith(isPosting: true);

    if (!state.isValid) return;

    await createTaskCallback(
        int.parse(idUser!),
        state.description.value,
        state.dropdown.value,
        state.dropdowPriority.value,
        state.dropdowDate.value);

    // state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final description = Description.dirty(state.description.value);
    final dropdown = Dropdow.dirty(state.dropdown.value);
    final dropdownDate = DropdowDate.dirty(state.dropdowDate.value);
    final dropdownPriority = DropdowPriority.dirty(state.dropdowPriority.value);

    state = state.copyWith(
        isFormPosted: true,
        description: description,
        dropdown: dropdown,
        dropdowDate: dropdownDate,
        dropdowPriority: dropdownPriority,
        isValid: Formz.validate(
            [description, dropdown, dropdownDate, dropdownPriority]));
  }
}

//! 1 - State del provider
class TaskFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Description description;
  final Dropdow dropdown;
  final DropdowDate dropdowDate;
  final DropdowPriority dropdowPriority;

  TaskFormState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.description = const Description.pure(),
      this.dropdown = const Dropdow.pure(),
      this.dropdowDate = const DropdowDate.pure(),
      this.dropdowPriority = const DropdowPriority.pure()});

  TaskFormState copyWith(
          {bool? isPosting,
          bool? isFormPosted,
          bool? isValid,
          Description? description,
          Dropdow? dropdown,
          DropdowDate? dropdowDate,
          DropdowPriority? dropdowPriority}) =>
      TaskFormState(
          isPosting: isPosting ?? this.isPosting,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isValid: isValid ?? this.isValid,
          description: description ?? this.description,
          dropdown: dropdown ?? this.dropdown,
          dropdowDate: dropdowDate ?? this.dropdowDate,
          dropdowPriority: dropdowPriority ?? this.dropdowPriority);

  @override
  String toString() {
    return '''
  TaskFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    description: $description
    dropdown: $dropdown
    dropdownDate: $dropdowDate
    dropdpwnPriority: $dropdowPriority
''';
  }
}
