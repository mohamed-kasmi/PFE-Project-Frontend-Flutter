import 'package:flutter/material.dart';
import 'package:pdcs_frontend/models/machine.dart';

class InfoTableWidget extends StatelessWidget {
  final Machine data;

  const InfoTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Détails de la Machine',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.speed, 'TRS en temps réel', '${data.oee.toStringAsFixed(1)}%'),
            _buildInfoRow(Icons.access_time, 'Temps', data.time),
            _buildInfoRow(Icons.timer, 'Cycle Time (s)', data.cycleTime.toStringAsFixed(2)),
            _buildInfoRow(Icons.check_circle, 'Total produit', data.total.toString()),
            _buildInfoRow(Icons.assignment, 'À faire', data.toDo.toString()),
          ],
        ),
      ),
    );
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
