import 'package:flutter/material.dart';

class PlusMinusButtons extends StatelessWidget {
  final VoidCallback deleteQuantity;
  final VoidCallback addQuantity;
  final String text;
  const PlusMinusButtons(
      {Key? key,
      required this.addQuantity,
      required this.deleteQuantity,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        (int.parse(text) > 0)
            ? IconButton(
                onPressed: deleteQuantity,
                icon: const Icon(Icons.remove, color: Colors.red))
            : const SizedBox(width: 50),
        Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
        IconButton(
            onPressed: addQuantity,
            icon: const Icon(Icons.add, color: Colors.green)),
      ],
    );
  }
}
