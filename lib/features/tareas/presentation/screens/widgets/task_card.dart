import 'package:flutter/material.dart';
import 'package:mensaeria_alv/features/tareas/domain/domain.dart';

class TaskCard extends StatelessWidget {
  final TaskUser taskUser;
  const TaskCard({super.key, required this.taskUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
            margin: const EdgeInsets.only(left: 15),
            width: 52,
            height: 90,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: ShapeDecoration(
                            gradient:
                                getGradientColorForPriority(taskUser.priority),
                            shape: const OvalBorder(),
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
                    taskUser.userId,
                    style: const TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 16,
                      fontFamily: 'Epilogue',
                      fontWeight: FontWeight.w700,
                      height: 0.09,
                    ),
                  ),
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
                    taskUser.timestamp,
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
            child: IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
          )
        ],
      ),
    );
  }
}

LinearGradient getGradientColorForPriority(String priority) {
  if (priority == 'Alta') {
    return const LinearGradient(
      colors: <Color>[Color(0xffFE1157), Color(0xffff809d)],
    );
  } else if (priority == 'Media') {
    return const LinearGradient(
      colors: <Color>[Color(0xffFF9234), Color(0xffFFCD3C)],
    );
  } else if (priority == 'Baja') {
    return const LinearGradient(
      colors: <Color>[Color(0xff1E2A78), Color(0xff49BCF6)],
    );
  }

  // Valor predeterminado si no coincide con ninguna prioridad
  return const LinearGradient(
    colors: <Color>[Color(0xff000000), Color(0xff000000)],
  );
}
