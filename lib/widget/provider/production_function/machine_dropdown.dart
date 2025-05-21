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
    final bool hasValue = selectedMachine != null && selectedMachine!.isNotEmpty;
    return DropdownButtonFormField<String>(
      value: selectedMachine,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.factory, color: Colors.blue[900]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[900]!, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[700]!, width: 3),
        ),
        filled: true,
        fillColor: Colors.blue[50],
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        hintText: hasValue ? null : "Select Machine",
      ),
      style: TextStyle(
        color: Colors.blue[900],
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      iconEnabledColor: Colors.blue[900],
      dropdownColor: Colors.white,
      items: machineList.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value,
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
