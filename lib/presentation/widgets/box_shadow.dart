import 'package:flutter/material.dart';

class CustomBoxShadow {
  
  static List<BoxShadow> cardBoxShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 10,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> iconBoxShadows = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 20,
      offset: const Offset(0, 0),
    ),
  ];
}
