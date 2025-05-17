import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:pdcs_frontend/models/machine.dart';

class InfoTableWidget extends StatelessWidget {
  final Machine data;

  const InfoTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final content = Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Machine Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.speed, 'Real-time OEE', '${data.oee.toStringAsFixed(1)}%'),
            _buildInfoRow(Icons.access_time, 'Time', data.time),
            _buildInfoRow(Icons.timer, 'Cycle Time (s)', data.cycleTime.toStringAsFixed(2)),
            _buildInfoRow(Icons.check_circle, 'Total Produced', data.total.toString()),
            _buildInfoRow(Icons.assignment, 'To DO', data.toDo.toString()),
          ],
        ),
      ),
    );

    if (kIsWeb) {
      // Web version: no layout constraint
      return content;
    } else {
      // Android version: constrain width and allow scroll
      return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: screenWidth < 600 ? double.infinity : 500),
          child: SingleChildScrollView(child: content),
        ),
      );
    }
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                )),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
