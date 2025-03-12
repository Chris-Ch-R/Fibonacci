import 'package:flutter/material.dart';

import 'fibonacci_controller.dart';
import 'fibonacci_model.dart';
import 'widgets/fibonacci_item.dart';
import 'widgets/fibonacci_selected_list.dart';

class FibonacciPage extends StatefulWidget {
  const FibonacciPage({super.key});

  @override
  State<FibonacciPage> createState() => _FibonacciPageState();
}

class _FibonacciPageState extends State<FibonacciPage> {
  int SIZE = 50;
  List<int> fibonacciList = [];
  Map<int, FibonacciModel> fibonacciIconsList = {};
  Map<FibonacciIcon, List<FibonacciModel>> selectedFibonacciNumber = {};
  FibonacciModel? lastPopItem;
  final Map<int, GlobalKey> _keys = {};
  final ScrollController _scrollController = ScrollController();

  void generateFibonacci(int n) {
    if (n <= 0) return;
    if (n >= 1) fibonacciList.add(0);
    if (n >= 2) fibonacciList.add(1);

    for (int i = 2; i < n; i++) {
      fibonacciList.add(fibonacciList[i - 1] + fibonacciList[i - 2]);
    }

    for (final (int index, int number) in fibonacciList.indexed) {
      final fibonacciNumberWithIcon = FibonacciModel(
        index: index,
        number: number,
        icon: FibonacciController.getRandomIcon(),
      );
      fibonacciIconsList[index] = fibonacciNumberWithIcon;
    }
  }

  void onAddItem(FibonacciModel data) {
    if (selectedFibonacciNumber[data.icon] == null) {
      selectedFibonacciNumber[data.icon] = [];
    }
    selectedFibonacciNumber[data.icon]!.add(data);

    if (fibonacciIconsList[data.index] != null) {
      setState(() {
        fibonacciIconsList[data.index]!.isSelected = true;
      });
      showModalBottomSheet(
        context: context,
        builder: (context) => FibonacciSelectedList(
          fibonacciIconsList: selectedFibonacciNumber[data.icon] ?? [],
          selectedFibonacci: data,
          onRemoveItem: (FibonacciModel fibonacci) {
            onRemoveItem(fibonacci);
            Navigator.pop(context);
          },
        ),
      );
    }
  }

  void onRemoveItem(FibonacciModel data) {
    selectedFibonacciNumber[data.icon]!.remove(data);
    if (fibonacciIconsList[data.index] != null) {
      setState(() {
        lastPopItem = data;
        fibonacciIconsList[data.index]!.isSelected = false;
      });
    }
    scrollToIndex(data.index);
  }

  void scrollToIndex(int index) {
    double itemHeight = 0.0;

    final unselectedList = fibonacciIconsList.values
        .where(
          (fibo) => fibo.isSelected == false,
        )
        .toList();
    final scrollToIndex = unselectedList.indexWhere(
      (element) => index == element.index,
    );
    BuildContext? context;
    BuildContext? context2;
    for (var key in _keys.keys) {
      if (_keys[key]?.currentContext != null && _keys[key + 1]?.currentContext != null) {
        context = _keys[key]?.currentContext;
        context2 = _keys[key + 1]?.currentContext;
        break;
      }
    }
    if (context != null && context2 != null) {
      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero).dy;
      final RenderBox box2 = context2.findRenderObject() as RenderBox;
      final position2 = box2.localToGlobal(Offset.zero).dy;
      itemHeight = position2 - position;
    }

    double targetOffset = (scrollToIndex * itemHeight) - itemHeight;

    Future.delayed(const Duration(milliseconds: 250)).then(
      (value) {
        _scrollController.animateTo(
          targetOffset,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void initState() {
    generateFibonacci(SIZE);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fibonacci App"),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: fibonacciIconsList.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (context, index) {
          if (fibonacciIconsList[index] != null) {
            final fibonacciItem = fibonacciIconsList[index];
            final number = fibonacciItem!.number;
            final trailingIcon = FibonacciController.getIconData(fibonacciItem.icon);
            final isSelected = fibonacciItem.isSelected;
            _keys[index] = GlobalKey();
            if (trailingIcon != null && isSelected == false) {
              return FibonacciItem(
                key: _keys[index],
                index: index,
                number: number,
                trailingIcon: Icon(trailingIcon),
                itemColor: lastPopItem == fibonacciItem ? Colors.red : Colors.white,
                onTap: () {
                  onAddItem(fibonacciItem);
                },
              );
            }
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
