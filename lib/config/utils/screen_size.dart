import 'package:flutter/material.dart';

double screenWidth = 0.0;
double screenHeight = 0.0;

extension ScreenSize on double {
  double getScreenWidth({BuildContext? context, double multiplier = 1.0}) {
    double width = MediaQuery.of(context!).size.width;
    width = width * multiplier;
    return width;
  }

  double getScreenHeight({BuildContext? context, double multiplier = 1.0}) {
    double height = MediaQuery.of(context!).size.height;
    height = height * multiplier;
    return height;
  }
}
