import 'package:flutter/material.dart';

class FibonacciItem extends StatefulWidget {
  final int index;
  final int number;
  final Icon trailingIcon;
  final Color? itemColor;

  final VoidCallback onTap;

  const FibonacciItem({super.key, required this.index, required this.number, required this.trailingIcon, required this.onTap, this.itemColor});

  @override
  State<FibonacciItem> createState() => _FibonacciItemState();
}

class _FibonacciItemState extends State<FibonacciItem> {

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text("index: ${widget.index} Number: ${widget.number}"),
      trailing: widget.trailingIcon,
      onTap: widget.onTap,
      tileColor: widget.itemColor,
    );
  }
}
