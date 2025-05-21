import 'package:flutter/material.dart';

class DateSelectorWidget extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime?, bool) onDateSelected;

  const DateSelectorWidget({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildDatePicker(context, true)),
        SizedBox(width: 16),
        Expanded(child: _buildDatePicker(context, false)),
      ],
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isStartDate) {
    return GestureDetector(
      onTap: () => _selectDate(context, isStartDate),
      child: InputDecorator(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.calendar_today, color: Colors.blue[900]),
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
        ),
        child: Text(
          isStartDate
              ? (startDate != null ? _formatDate(startDate!) : 'Start Date')
              : (endDate != null ? _formatDate(endDate!) : 'End Date'),
          style: TextStyle(
            fontSize: 16,
            color: (isStartDate ? startDate : endDate) != null
                ? (isStartDate ? Colors.blue[900] : Colors.blue[700])
                : Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  String _formatDate(DateTime date) {
    // Format as YYYY-MM-DD for clarity
    return "${date.year.toString()}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blue[900]!, // header background color
              onPrimary: Colors.white,    // header text color
              onSurface: Colors.blue[900]!, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue[900], // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      onDateSelected(picked, isStartDate);
    }
  }
}
