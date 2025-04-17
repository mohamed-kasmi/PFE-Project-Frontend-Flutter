import 'package:flutter/material.dart';

Widget buildTabbedSelector() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ['Press 1', 'Press 2', 'Press 3', 'Press 4'].map((text) {
        return ElevatedButton(
          onPressed: () {},
          child: Text(text),
        );
      }).toList(),
    ),
  );
}
