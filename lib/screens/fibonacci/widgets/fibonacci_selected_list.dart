import 'package:flutter/material.dart';

import '../fibonacci_controller.dart';
import '../fibonacci_model.dart';
import 'fibonacci_item.dart';

class FibonacciSelectedList extends StatefulWidget {
  final List<FibonacciModel> fibonacciIconsList;
  final FibonacciModel selectedFibonacci;
  final void Function(FibonacciModel) onRemoveItem;

  const FibonacciSelectedList({super.key, required this.fibonacciIconsList, required this.onRemoveItem, required this.selectedFibonacci});

  @override
  State<FibonacciSelectedList> createState() => _FibonacciSelectedListState();
}

class _FibonacciSelectedListState extends State<FibonacciSelectedList> {
  final Map<int, GlobalKey> _keys = {};

  void scrollToIndex(int index) {
    final key = _keys[index];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void initState() {
    widget.fibonacciIconsList.sort((a, b) => a.index.compareTo(b.index),);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        scrollToIndex(widget.fibonacciIconsList.indexWhere(
          (fibonacciItem) => widget.selectedFibonacci == fibonacciItem,
        ));
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.fibonacciIconsList.length,
      itemBuilder: (context, index) {

        _keys[index] = GlobalKey(); // สร้าง GlobalKey ให้แต่ละรายการ
        final number = widget.fibonacciIconsList[index].number;
        final trailingIcon = FibonacciController.getIconData(widget.fibonacciIconsList[index].icon);
        final trailingIconData = widget.fibonacciIconsList[index].icon;
        final isSelected = widget.fibonacciIconsList[index].isSelected;
        if (trailingIcon != null && trailingIconData == widget.selectedFibonacci.icon && isSelected == true) {
          return FibonacciItem(
            key: _keys[index],
            index: widget.fibonacciIconsList[index].index,
            number: number,
            trailingIcon: Icon(trailingIcon),
            itemColor: widget.selectedFibonacci == widget.fibonacciIconsList[index] ? Colors.green : Colors.white,
            onTap: () => widget.onRemoveItem(widget.fibonacciIconsList[index]),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
