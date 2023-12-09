import 'package:flutter/material.dart';
import 'package:mensaeria_alv/features/delivery/domain/domain.dart';
import 'package:intl/intl.dart';

class TaskDeliveryCard extends StatelessWidget {
  final TaskDelivery taskDelivery;
  const TaskDeliveryCard({super.key, required this.taskDelivery});

  @override
  Widget build(BuildContext context) {
    String fechaString = taskDelivery.timestamp;

    // Parsear la fecha a un objeto DateTime
    DateTime fecha = DateTime.parse(fechaString);

    // Crear un formateador de fecha para el formato deseado (día, mes y año)
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');

    // Formatear la fecha en el formato deseado
    String fechaFormateada = dateFormat.format(fecha);
    return Container(
      margin: const EdgeInsets.only(top: 20),
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
              const Text('Prioridad'),
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
                          gradient: getGradientColorForPriority(
                              taskDelivery.priority),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        taskDelivery.priority,
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
              taskDelivery.descripcion,
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
