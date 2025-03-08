import 'package:flutter/material.dart';
class TextFieldWidget extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  TextFieldWidget({
    required this.labelText,
    required this.controller,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white),
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.white),
        filled: true,
        fillColor: Colors.blue[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
