// ignore_for_file: camel_case_types

import 'package:build_context_provider/build_context_provider.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mensaeria_alv/features/shared/presentation/providers/deliverys_provider.dart';
import 'package:mensaeria_alv/features/shared/presentation/providers/task_form_provider.dart';
import 'package:mensaeria_alv/features/shared/presentation/providers/task_list_provider.dart';

import '../../../shared/widgets/widgets.dart';

class CreateTaskScreen extends StatelessWidget {
  const CreateTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            const ListenerThatRunsFunctionsWithBuildContext(),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,
                        size: 40, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear Tarea',
                    style:
                        textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              height: size.height - 260, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _TaskForm(),
            ),
          ],
        ),
      ))),
    );
  }
}

class _TaskForm extends ConsumerWidget {
  const _TaskForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(deliverysProvider.notifier).loadDelivery();
    final taskForm = ref.watch(taskFormProvider);

    ref.listen(taskProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Text('Nueva Tarea', style: textStyles.titleMedium),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Descripción',
            keyboardType: TextInputType.text,
            maxLines: 2,
            onChanged: ref.read(taskFormProvider.notifier).onDescriptionChange,
            errorMessage: taskForm.description.errorMessage,
          ),
          const SizedBox(height: 10),
          const widgetDate(),
          const SizedBox(height: 10),
          const _DropdownDelivery(),
          _DropdownPriority(),
          const Spacer(flex: 1),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                text: 'Crear Tarea',
                buttonColor: Colors.black,
                onPressed: () {
                  ref.read(taskFormProvider.notifier).onFormSubmit();
                },
              )),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class widgetDate extends ConsumerWidget {
  const widgetDate({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    return EasyDateTimeLine(
      locale: 'es',
      initialDate: yesterday,
      onDateChange: (selectedDate) {
        ref
            .watch(taskFormProvider.notifier)
            .onDropdownDateChange(selectedDate.toString());
      },
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
  const _DropdownDelivery();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliverysState = ref.watch(deliverysProvider);
    final taskForm = ref.watch(taskFormProvider);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        DropdownButtonFormField2<String>(
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            errorText: taskForm.dropdown.errorMessage,
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
