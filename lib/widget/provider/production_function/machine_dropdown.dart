import 'package:flutter/material.dart';

class MachineDropdownWidget extends StatelessWidget {
  final List<String> machineList;
  final String? selectedMachine;
  final Function(String?) onChanged;

  const MachineDropdownWidget({
    super.key,
    required this.machineList,
    required this.selectedMachine,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedMachine,
      decoration: InputDecoration(
        labelText: "Select Machine",
        prefixIcon: Icon(Icons.factory),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items: machineList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}