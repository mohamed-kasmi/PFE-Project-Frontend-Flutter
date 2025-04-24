import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final double barWidth;
  final Color barColor;

  const CustomCard({
    super.key,
    required this.child,
    this.barWidth = 5.0,
    this.barColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            width: barWidth,
            height: double.infinity,
            decoration: BoxDecoration(
              color: barColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
