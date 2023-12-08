import 'package:flutter/material.dart';
import 'package:flutter_emoji_feedback/flutter_emoji_feedback.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mensaeria_alv/features/shared/shared.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/form_task_provider%20copy.dart';
import 'package:mensaeria_alv/features/tasks/presentation/providers/task_finish_provider.dart';
import 'package:mensaeria_alv/features/tasks/presentation/screens/widgets/task_card.dart';

class TaskFinishScreen extends ConsumerWidget {
  final String taskId;
  const TaskFinishScreen({super.key, required this.taskId});

  void showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Tarea Actualizada')));
  }

  void showSnackbarError(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No has calificado la tarea!')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskState = ref.watch(taskViewfinishProvider(taskId));

    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return Scaffold(
      body: taskState.isLoading
          ? const FullScreenLoader()
          : GeometricalBackground(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 100),
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
                      Text('Finalizar Tarea',
                          style: textStyles.titleLarge
                              ?.copyWith(color: Colors.white)),
                      const Spacer(flex: 2),
                    ],
                  ),
                  const SizedBox(height: 80),
                  Container(
                    height:
                        size.height - 400, // 80 los dos sizebox y 100 el Ã­cono
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(100)),
                    ),
                    child: _TaskForm(task: taskState.task!),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 60),
        width: 200,
        height: 60,
        child: CustomFilledButton(
          text: 'Finalizar Tarea!',
          buttonColor: Colors.black,
          onPressed: () {
            if (taskState.task == null) return;

            ref
                .read(formTaskFinishProvider(taskState.task!).notifier)
                .onFormSubmit()
                .then((value) {
              if (!value) return;
              showSnackbar(context);
            });
          },
        ),
      ),
    );
  }
}

class _TaskForm extends ConsumerWidget {
  final TaskUser task;

  const _TaskForm({required this.task});

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = Theme.of(context).textTheme;
    String fechaString = task.timestamp;

    // Parsear la fecha a un objeto DateTime
    DateTime fecha = DateTime.parse(fechaString);

    // Crear un formateador de fecha para el formato deseado (día, mes y año)
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Formatear la fecha en el formato deseado
    String fechaFormateada = dateFormat.format(fecha);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        const SizedBox(height: 20),
        Text('Califica esta tarea para finalizar',
            style: textStyles.titleSmall),
        const SizedBox(height: 70),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: 200,
          decoration: ShapeDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Prioridad ${task.id}'),
                  SizedBox(
                    width: 52,
                    height: 20,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: Container(
                            width: 52,
                            height: 20,
                            decoration: ShapeDecoration(
                              gradient:
                                  getGradientColorForPriority(task.priority),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            task.priority,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Color(0xFFFCFCFC),
                              fontSize: 15,
                              fontFamily: 'Epilogue',
                              fontWeight: FontWeight.w700,
                              height: 0.04,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: 70,
                margin: const EdgeInsets.only(top: 15),
                child: Text(
                  task.descripcion,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Epilogue',
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Divider(),
              Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          fechaFormateada,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF555555),
                            fontSize: 13,
                            fontFamily: 'Epilogue',
                            fontWeight: FontWeight.w500,
                            height: 0.12,
                          ),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        EmojiFeedback(
          customLabels: const [
            'Terrible',
            'Mal',
            'Bien',
            'Muy bien',
            'Asombroso'
          ],
          emojiPreset: const [
            EmojiModel(src: 'assets/classic_terrible.svg', label: 'terrible'),
            EmojiModel(src: 'assets/classic_bad.svg', label: 'mal'),
            EmojiModel(src: 'assets/classic_good.svg', label: 'bien'),
            EmojiModel(src: 'assets/classic_very_good.svg', label: 'muy bien'),
            EmojiModel(src: 'assets/classic_awesome.svg', label: 'bad'),
          ],
          animDuration: const Duration(milliseconds: 200),
          curve: Curves.easeInQuad,
          labelTextStyle: const TextStyle(
              color: Colors.black, decoration: TextDecoration.none),
          inactiveElementScale: .7,
          onChanged: (value) {
            ref
                .read(formTaskFinishProvider(task).notifier)
                .onRatingChange(value);
          },
        ),
      ]),
    );
  }
}
