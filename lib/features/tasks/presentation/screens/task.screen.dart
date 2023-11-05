import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';

import '../../../shared/presentation/providers/providers.dart';
import '../../../shared/presentation/providers/task_form_provider.dart';
import '../providers/task_provider.dart';

class TaskScreen extends ConsumerWidget {
  final String taskId;
  const TaskScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewProvider(taskId));
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Editar tarea')),
      ),
      body: taskState.isLoading
          ? const FullScreenLoader()
          : _ProductView(product: taskState.task!),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.save_as_outlined),
      ),
    );
  }
}

class _ProductView extends StatelessWidget {
  final TaskUser product;

  const _ProductView({required this.product});

  @override
  Widget build(BuildContext context) {
    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: ListView(
        children: [
          const SizedBox(
            height: 250,
            width: 600,
            // child: _ImageGallery(images: product.images),
          ),
          const SizedBox(height: 10),
          // Center(child: Text(product.title, style: textStyles.titleSmall)),
          const SizedBox(height: 10),
          _ProductInformation(product: product),
        ],
      ),
    );
  }
}

class _ProductInformation extends ConsumerWidget {
  final TaskUser product;
  const _ProductInformation({required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(deliverysProvider.notifier).loadDelivery();
    final taskForm = ref.watch(taskFormProvider);

    // ref.listen(taskProvider, (previous, next) {
    //   if (next.errorMessage.isEmpty) return;
    //   showSnackbar(context, next.errorMessage);
    // });
    final parsearFecha = DateTime.parse(product.timestamp);
    print(parsearFecha);
    // final formatoFecha = DateFormat('MMMM dd, yyyy').format(parsearFecha);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTaskField(
            maxLines: 5,
            label: 'Descripción',
            keyboardType: TextInputType.multiline,
            initialValue: product.descripcion,
          ),
          const SizedBox(height: 15),
          WidgetDate(dateTime: parsearFecha),
          const SizedBox(height: 15),
          _DropdownDelivery(selectedDeliveryId: product.deliveryId),
          _DropdownPriority(selectedPrority: product.priority),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class WidgetDate extends StatelessWidget {
  final DateTime dateTime;
  const WidgetDate({super.key, required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      locale: 'es',
      initialDate: dateTime,
      // onDateChange: (selectedDate) {
      //   ref
      //       .watch(taskFormProvider.notifier)
      //       .onDropdownDateChange(selectedDate.toString());
      // },
      dayProps: const EasyDayProps(
        height: 56.0,
        // You must specify the width in this case.
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
  const _DropdownDelivery({this.selectedDeliveryId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliverysState = ref.watch(deliverysProvider);
    // final taskForm = ref.watch(taskFormProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            // errorText: taskForm.dropdown.errorMessage,
            border: OutlineInputBorder(borderSide: BorderSide.none),
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
                .read(taskFormProvider.notifier)
                .onDropdownChange(int.parse(value!));
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
  _DropdownPriority({this.selectedPrority});

  final List<String> selectedPriority = ["Alta", "Media", "Baja"];
  final List<IconData> priorityIcons = [
    Icons.warning_amber, // Icono para "Alta"
    Icons.priority_high, // Icono para "Media"
    Icons.access_alarm_sharp, // Icono para "Baja"
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final taskForm = ref.watch(taskFormProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
            // errorText: taskForm.dropdowPriority.errorMessage,
            border: OutlineInputBorder(borderSide: BorderSide.none),
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
                .read(taskFormProvider.notifier)
                .onDropdownPriorityChange(value.toString());
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
