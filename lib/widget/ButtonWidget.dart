import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final TextStyle textStyle;

  ButtonWidget({
    required this.text,
    required this.onPressed,
    this.height = 50.0, // Default height
    this.width = double.infinity, // Default width to fill parent container
    this.textStyle = const TextStyle(fontSize: 18), // Default text style
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: textStyle, // Use passed text style
        ),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.blue[900],
          backgroundColor: Colors.white,
          shadowColor: Colors.blue[900],
          elevation: 5,
        ),
      ),
    );
  }
}
