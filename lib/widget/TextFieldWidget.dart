import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final bool obscureText;
  final Color iconColor; // New parameter for icon color
  final Color textColor; // New parameter for text color

  TextFieldWidget({
    required this.labelText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.iconColor = Colors.black, // Default color
    this.textColor = Colors.black, // Default color
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor), // Set text color
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor), // Set label color
        prefixIcon: Icon(icon, color: iconColor), // Set icon color
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white), // White border
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0), // Highlight border
        ),
      ),
    );
  }
}
