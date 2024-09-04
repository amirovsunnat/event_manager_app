import 'package:flutter/material.dart';

Color parseColor(String color) {
  try {
    final colorValue = int.parse(color, radix: 16);
    return Color(colorValue).withOpacity(1.0);
  } catch (e) {
    return Colors.red;
  }
}
