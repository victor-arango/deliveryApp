import 'package:flutter/material.dart';
import 'package:mensaeria_alv/config/utils/screen_size.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  String? text;

  NoDataWidget({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SizedBox(
          width: screenWidth.getScreenWidth(context: context, multiplier: 0.5),
          height:
              screenHeight.getScreenHeight(context: context, multiplier: 0.5),
          child: Lottie.asset('assets/images/no-data.json'),
        ),
        Container(
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(
              bottom: screenHeight.getScreenHeight(
                  context: context, multiplier: 0.5),
            ),
            child: const Text(
              'No hay tareas pendientes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
            ))
      ],
    );
  }
}
