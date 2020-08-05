import 'package:flutter/cupertino.dart';

class AppSizes {
  static double screenWidth;
  static double screenHeight;
  
  static double hUnit;
  static double wUnit;

  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  void init(BoxConstraints constraints) {
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;
    hUnit = screenHeight / 100;
    wUnit = screenWidth / 100;
  }
}