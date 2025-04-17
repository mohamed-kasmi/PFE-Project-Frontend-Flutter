import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData icon;
  final Color iconColor;
  final Color textColor;
  final Widget? suffixIcon;  // Add this line

  TextFieldWidget({
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.iconColor,
    required this.textColor,
    this.suffixIcon,  // Add this line
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor),
        prefixIcon: Icon(icon, color: iconColor),
        suffixIcon: suffixIcon,  // Include the suffixIcon in the decoration
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
