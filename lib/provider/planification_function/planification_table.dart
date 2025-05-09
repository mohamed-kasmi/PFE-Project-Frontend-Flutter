import 'package:flutter/material.dart';
import 'planification_textfield.dart';
import 'package:video_player/video_player.dart';

class PlanificationTable extends StatefulWidget {
  final List<List<String>> table;
  final List<List<TextEditingController?>> controllers;
  final bool Function(String) isValidWorkCenter;
  final void Function() onChanged;

  const PlanificationTable({
    required this.table,
    required this.controllers,
    required this.isValidWorkCenter,
    required this.onChanged,
    super.key,
  });

  @override
  _PlanificationTableState createState() => _PlanificationTableState();
}

class _PlanificationTableState extends State<PlanificationTable> {
  late VideoPlayerController _videoController;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset('assets/plan.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoInitialized = true;
        });
        _videoController.setLooping(true);
        _videoController.play();
      });
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show video if table is empty
    if (widget.table.isEmpty) {
      return Stack(
        children: [
          // Background Video
          if (_isVideoInitialized)
            Positioned.fill(
              child: VideoPlayer(_videoController),

            ),
          // Placeholder or empty space
        ],
      );
    }

    return Stack(
      children: [
        // Background Video
        if (_isVideoInitialized)
          Positioned.fill(
            child: VideoPlayer(_videoController),
          ),
        // Table Content
        Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    headingRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.grey.shade200),
                    dataRowColor:
                    MaterialStateColor.resolveWith((states) => Colors.transparent),
                    columns: List.generate(
                      widget.table[0].length + 1,
                          (index) => DataColumn(
                        label: Text(
                          index == widget.table[0].length
                              ? 'Cycle Time'
                              : widget.table[0][index],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    rows: List.generate(
                      widget.table.length - 1,
                          (i) => DataRow(
                        cells: List.generate(
                          widget.table[0].length + 1,
                              (j) {
                            if (j == widget.table[0].length) {
                              double remainingHours =
                                  double.tryParse(widget.table[i + 1][7]) ?? 0;
                              int remainingQty = int.tryParse(widget.table[i + 1][3]) ?? 1;
                              double cycleTime =
                              remainingQty != 0
                                  ? ((remainingHours * 3600) / remainingQty)
                                  : 0;
                              return DataCell(Text(
                                cycleTime.toStringAsFixed(2),
                                style: const TextStyle(fontSize: 14),
                              ));
                            }

                            final controller = widget.controllers[i + 1][j];
                            return controller != null
                                ? DataCell(PlanificationTextField(
                              controller: controller,
                              isValid: widget.isValidWorkCenter(controller.text),
                              onChanged: widget.onChanged,
                            ))
                                : DataCell(Text(
                              widget.table[i + 1][j],
                              style: const TextStyle(fontSize: 14),
                            ));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
