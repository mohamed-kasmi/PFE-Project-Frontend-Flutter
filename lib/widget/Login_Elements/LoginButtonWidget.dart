import 'package:flutter/material.dart';
class LoginButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  LoginButtonWidget({
    required this.text,
    required this.onPressed,
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
        shadowColor: Colors.blue[900],
        elevation: 5,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
