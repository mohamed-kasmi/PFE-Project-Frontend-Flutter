import 'package:flutter/material.dart';
class RoleSelectionWidget extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String?> onChanged;
  RoleSelectionWidget({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          activeColor: Colors.white,
        ),
        Text(value,
          style: TextStyle(color: Colors.white, fontSize: 16),),
      ],
    );
  }
}
