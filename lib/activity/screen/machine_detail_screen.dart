import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';  // Import the CircularPercentIndicator package
import '../../models/machine.dart'; // Import the Machine model

class MachineDetailScreen extends StatelessWidget {
  final Machine machine;

  const MachineDetailScreen({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = machine.quantityPrepared / machine.totalQuantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(machine.name),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Machine Details
              Text(
                "Machine Name: ${machine.name}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Total Quantity: ${machine.totalQuantity}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Quantity Prepared: ${machine.quantityPrepared}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                "Quantity To Do: ${machine.quantityToDo}",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),

              // Circular Percentage Widget
              Center(
                child: CircularPercentIndicator(
                  radius: 120.0,  // Adjust the size of the circle
                  lineWidth: 12.0, // Width of the line

                  animation: true,
                  percent: progress,  // Progress value (from 0.0 to 1.0)
                  center: Text(
                    "${(progress * 100).toStringAsFixed(1)}%",  // Display percentage
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  circularStrokeCap: CircularStrokeCap.round, // Round the edges
                  progressColor: Colors.blue,  // Color for the progress circle
                  backgroundColor: Colors.grey[300] ?? Colors.grey,  // Ensure background color is non-null
                ),

              ),
              SizedBox(height: 20),

              // Action Button (e.g., View More, Edit, etc.)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // You can add more actions here (e.g., edit the machine, etc.)
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Action for ${machine.name}')),
                    );
                  },
                  child: Text('Action for ${machine.name}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[900], // Use backgroundColor instead of primary
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
