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
        filled: true,
        fillColor: Colors.white, // White background
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2), // Blue border color and width
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2), // Blue border color
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2), // Blue border color on focus
        ),
      ),
    );
  }
}
