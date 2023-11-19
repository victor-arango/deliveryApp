import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/providers.dart';
import '../../../shared/presentation/providers/providers.dart';
import '../../../shared/presentation/providers/task_form_provider.dart';

class TaskScreen extends ConsumerWidget {
  final String taskId;
  const TaskScreen({super.key, required this.taskId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tarea Actualizada')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewProvider(taskId));

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Editar tarea')),
      ),
      body: taskState.isLoading
          ? const FullScreenLoader()
          : _ProductView(task: taskState.task!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (taskState.task == null) return;

          ref.read(formTaskProvider(taskState.task!).notifier).onFormSubmit();
        },
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _ProductView extends ConsumerWidget {
  final TaskUser task;

  const _ProductView({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ListView(
        children: [
          const SizedBox(
            height: 250,
            width: 600,
          ),
          const SizedBox(height: 10),
          const SizedBox(height: 10),
          _ProductInformation(task: task),
        ],
      ),
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final TaskUser task;
  const _ProductInformation({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(deliverysProvider.notifier).loadDelivery();
    final taskForm = ref.watch(formTaskProvider(task));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTaskField(
            maxLines: 5,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: taskForm.description.value,
            errorMessage: taskForm.description.errorMessage,
            onChanged: (value) => ref
                .read(formTaskProvider(task).notifier)
                .onDescriptionChanged(value),
          ),
          const SizedBox(height: 15),
          WidgetDate(
            task: task,
          ),
          const SizedBox(height: 15),
          _DropdownDelivery(
            selectedDeliveryId: taskForm.deliveryId.value.toString(),
            task: task,
          ),
          _DropdownPriority(
            selectedPrority: taskForm.priority.value,
            task: task,
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class WidgetDate extends ConsumerWidget {
  final TaskUser task;
  const WidgetDate({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskForm = ref.watch(formTaskProvider(task));
    final parsearFecha = DateTime.parse(taskForm.timestamp.value);

    return EasyDateTimeLine(
      locale: 'es',
      initialDate: parsearFecha,
      onDateChange: (selectedDate) {
        ref
            .watch(formTaskProvider(task).notifier)
            .onDropDateChanged(selectedDate.toString());
      },
      dayProps: const EasyDayProps(
        height: 56.0,
        width: 124.0,
      ),
      headerProps: const EasyHeaderProps(
        selectedDateFormat: SelectedDateFormat.fullDateDMY,
      ),
      itemBuilder: (BuildContext context, String dayNumber, dayName, monthName,
          fullDate, isSelected) {
        return Container(
          //the same width that provided previously.
          width: 124.0,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xff000000) : null,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                monthName,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xff6D5D6E),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                dayNumber,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : const Color(0xff393646),
                ),
              ),
              const SizedBox(
                width: 8.0,
              ),
              Text(
                dayName,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : const Color(0xff6D5D6E),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DropdownDelivery extends ConsumerWidget {
  final String? selectedDeliveryId;
  final TaskUser task;
  const _DropdownDelivery({this.selectedDeliveryId, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliverysState = ref.watch(deliverysProvider);
    final taskForm = ref.watch(formTaskProvider(task));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            errorText: taskForm.deliveryId.errorMessage,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
          hint: const Text('Selecciona el mensajero',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              )),
          items: deliverysState.deliverys
              .map((delivery) => DropdownMenuItem<String>(
                    value: delivery.id,
                    child: Text(
                      delivery.fullname,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ))
              .toList(),
          value: selectedDeliveryId,
          onChanged: (value) {
            ref
                .watch(formTaskProvider(task).notifier)
                .onDropdownChanged(int.parse(value.toString()));
          },
          buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ])),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

class _DropdownPriority extends ConsumerWidget {
  final String? selectedPrority;
  final TaskUser task;
  _DropdownPriority({this.selectedPrority, required this.task});

  final List<String> selectedPriority = ["Alta", "Media", "Baja"];
  final List<IconData> priorityIcons = [
    Icons.warning_amber, // Icono para "Alta"
    Icons.priority_high, // Icono para "Media"
    Icons.access_alarm_sharp, // Icono para "Baja"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskForm = ref.watch(taskFormProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            errorText: taskForm.dropdowPriority.errorMessage,
            border: const OutlineInputBorder(borderSide: BorderSide.none),
          ),
          hint: const Text('Selecciona la prioridad',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              )),
          items: selectedPriority.asMap().entries.map((entry) {
            final int index = entry.key;
            final String priority = entry.value;
            return DropdownMenuItem(
              value: priority,
              child: Row(
                children: [
                  Icon(
                    priorityIcons[
                        index], // Icono correspondiente a la prioridad
                    color: Colors
                        .black, // Cambia el color del icono según tus preferencias
                  ),
                  const SizedBox(width: 8), // Espacio entre el icono y el texto
                  Text(
                    priority,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          value: selectedPrority,
          onChanged: (value) {
            ref
                .watch(formTaskProvider(task).notifier)
                .onDropdownPriorityChanged(value.toString());
          },
          buttonStyleData: ButtonStyleData(
              height: 50,
              padding: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 10,
                        offset: const Offset(0, 5))
                  ])),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
            ),
          ),
          dropdownStyleData: const DropdownStyleData(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white),
          ),
          menuItemStyleData: const MenuItemStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
