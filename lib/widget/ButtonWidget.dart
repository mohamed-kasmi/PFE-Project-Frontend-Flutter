import 'package:flutter/material.dart';
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  ButtonWidget({
    required this.text,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18),
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
    );
  }
}
