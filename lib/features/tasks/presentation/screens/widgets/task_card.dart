import 'package:flutter/material.dart';
import 'package:mensaeria_alv/features/tasks/domain/domain.dart';
import 'package:intl/intl.dart';

class TaskCard extends StatelessWidget {
  final TaskUser taskUser;
  const TaskCard({super.key, required this.taskUser});

  @override
  Widget build(BuildContext context) {
    String fechaString = taskUser.timestamp;

    // Parsear la fecha a un objeto DateTime
    DateTime fecha = DateTime.parse(fechaString);

    // Crear un formateador de fecha para el formato deseado (día, mes y año)
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Formatear la fecha en el formato deseado
    String fechaFormateada = dateFormat.format(fecha);

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      width: double.infinity,
      height: 97.87,
      decoration: ShapeDecoration(
        color: const Color(0xFFFCFCFC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 52,
            height: 90,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: ShapeDecoration(
                            gradient:
                                getGradientColorForPriority(taskUser.priority),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          taskUser.priority,
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
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              width: 200,
              height: 90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    taskUser.descripcion,
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 14,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
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
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: IconButton(
                onPressed: () {}, icon: const Icon(Icons.more_vert_outlined)),
          )
        ],
      ),
    );
  }
}

LinearGradient getGradientColorForPriority(String priority) {
  if (priority == 'Alta') {
    return const LinearGradient(
      colors: <Color>[Color(0xffFE1157), Color(0xffFE1157)],
    );
  } else if (priority == 'Media') {
    return const LinearGradient(
      colors: <Color>[Color(0xffFF9234), Color(0xffFF9234)],
    );
  } else if (priority == 'Baja') {
    return const LinearGradient(
      colors: <Color>[Color(0xff1E2A78), Color(0xff1E2A78)],
    );
  }

  // Valor predeterminado si no coincide con ninguna prioridad
  return const LinearGradient(
    colors: <Color>[Color(0xff000000), Color(0xff000000)],
  );
}
