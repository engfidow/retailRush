import 'package:flutter/material.dart';

class RadioChips extends StatefulWidget {
  final List<String> values;
  final int initialPosition;
  final Function(int index) onSelected;

  RadioChips(
      {required this.values,
      required this.onSelected,
      this.initialPosition = 0});

  @override
  _RadioChipsState createState() => _RadioChipsState();
}

class _RadioChipsState extends State<RadioChips> {
  late int current;

  @override
  void initState() {
    super.initState();
    current = widget.initialPosition;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        widget.values.length,
        (index) {
          return GestureDetector(
            onTap: () async {
              setState(() => current = index);
              widget.onSelected(index);
            },
            child: Container(
              height: 36,
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                color: index == current ? Colors.red : Colors.white,
              ),
              child: Text(widget.values[index],
                  style: TextStyle(
                      color: index == current ? Colors.white : Colors.black)),
            ),
          );
        },
      ),
    );
  }
}
