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
    final bool hasValue = selectedGranularity != null && selectedGranularity!.isNotEmpty;

    return DropdownButtonFormField<String>(
      value: selectedGranularity,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.calendar_view_week, color: Colors.blue[900]),
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
        hintText: hasValue ? null : "Select Granularity",
        hintStyle: TextStyle(
          color: Colors.blue[900]!.withOpacity(0.6),
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextStyle(
        color: Colors.blue[900],
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      iconEnabledColor: Colors.blue[900],
      dropdownColor: Colors.white,
      items: granularityOptions.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
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
