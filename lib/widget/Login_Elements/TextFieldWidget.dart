import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Color labelColor;

  TextFieldWidget({
    required this.labelText,
    required this.obscureText,
    required this.controller,
    required this.icon,
    this.iconColor = Colors.blue, // Default icon color
    this.textColor = Colors.blue, // Default text color
    this.labelColor = Colors.blue, // Default label color
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor), // Customize text color
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: iconColor), // Customize icon color
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor), // Customize label color
        filled: true,
        fillColor: Colors.white, // White background for the text field
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[100]!, width: 2),
        ),
      ),
    );
  }
}
