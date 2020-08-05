import 'dart:ui';

import 'package:flutter/material.dart';

class CustomClipPath extends CustomClipper<Path> {
  var radius=10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height-40);
    path.quadraticBezierTo(size.width/2, size.height, 0, size.height-40);
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}