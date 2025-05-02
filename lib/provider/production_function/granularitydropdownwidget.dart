import 'package:flutter/material.dart';

class GranularityDropdownWidget extends StatelessWidget {
  final List<String> granularityOptions;
  final String? selectedGranularity;
  final Function(String?) onChanged;

  const GranularityDropdownWidget({
    super.key,
    required this.granularityOptions,
    required this.selectedGranularity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedGranularity,
      decoration: InputDecoration(
        labelText: "Select Granularity",
        prefixIcon: Icon(Icons.calendar_view_week),
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items: granularityOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
