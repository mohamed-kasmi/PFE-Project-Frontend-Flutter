import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class StopButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const StopButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final bool isWeb = kIsWeb;
    final double width = isWeb ? 220 : MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width * 0.7 : 220;
    final double height = isWeb ? 160 : MediaQuery.of(context).size.width < 400 ? 120 : 160;
    final double borderRadius = isWeb ? 3 : 6;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 1,
            spreadRadius: 8,
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: const EdgeInsets.all(20),
          elevation: 8,
        ),
        onPressed: onPressed,
        child: isWeb
            ? const Text(
          'STOP',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        )
            : const FittedBox(
          child: Text(
            'STOP',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 2,
            ),
          ),
        ),
      ),
    );
  }
}
