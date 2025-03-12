import 'dart:math';

import 'package:flutter/material.dart';

import 'fibonacci_model.dart';

class FibonacciController {
  static FibonacciIcon getRandomIcon() {
    List<FibonacciIcon> icons = [
      FibonacciIcon.circle,
      FibonacciIcon.square,
      FibonacciIcon.cross,
    ];

    Random random = Random();
    return icons[random.nextInt(icons.length)];
  }

  static IconData? getIconData(FibonacciIcon icon) {
    IconData? iconData;
    switch (icon) {
      case FibonacciIcon.circle:
        iconData = Icons.circle;
        break;
      case FibonacciIcon.square:
        iconData = Icons.square;
        break;
      case FibonacciIcon.cross:
        iconData = Icons.close;
        break;
    }
    return iconData;
  }
}