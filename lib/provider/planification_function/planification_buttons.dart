import 'package:flutter/material.dart';

class PlanificationButtons extends StatelessWidget {
  final VoidCallback onPickFile;
  final VoidCallback onReset;
  final VoidCallback onSave;
  final VoidCallback onPublish;

  const PlanificationButtons({
    required this.onPickFile,
    required this.onReset,
    required this.onSave,
    required this.onPublish,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _styledButton(Icons.file_open, "Pick File", onPickFile, Colors.indigo),
        _styledButton(Icons.refresh, "Reset", onReset, Colors.red),
        _styledButton(Icons.save, "Save", onSave, Colors.teal),
        _styledButton(Icons.send, "Publish", onPublish, Colors.green),
      ],
    );
  }

  Widget _styledButton(IconData icon, String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 6,
        shadowColor: color.withOpacity(0.4),
      ),
    );
  }
}