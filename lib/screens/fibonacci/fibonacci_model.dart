import 'package:flutter/cupertino.dart';

enum FibonacciIcon {circle, square, cross}
class FibonacciModel {
  int number;
  int index;
  FibonacciIcon icon;
  bool isSelected;

  FibonacciModel({
    required this.index,
    required this.number,
    required this.icon,
    this.isSelected = false,
  });
}


