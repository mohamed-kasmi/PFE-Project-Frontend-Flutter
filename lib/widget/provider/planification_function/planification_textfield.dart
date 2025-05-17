import 'package:flutter/material.dart';

class PlanificationTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool isValid;
  final VoidCallback onChanged;

  const PlanificationTextField({
    required this.controller,
    required this.isValid,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: 3,
      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        border: InputBorder.none,
        counterText: '',
        errorText: isValid ? null : 'Format: A00',
      ),
      onChanged: (_) => onChanged(),
    );
  }
}
