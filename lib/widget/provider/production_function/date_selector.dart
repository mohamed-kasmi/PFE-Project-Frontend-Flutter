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
          labelText: isStartDate ? 'Start Date' : 'End Date',
          prefixIcon: Icon(Icons.calendar_today),
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        child: Text(
          isStartDate
              ? (startDate?.toString().substring(0, 10) ?? 'Select Date')
              : (endDate?.toString().substring(0, 10) ?? 'Select Date'),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    onDateSelected(picked, isStartDate);
  }
}
