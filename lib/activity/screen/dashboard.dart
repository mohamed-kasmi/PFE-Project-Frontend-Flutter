import 'package:flutter/material.dart';
import '../../models/machine.dart';  // Import the Machine class file
import 'machine_detail_screen.dart';  // Import the MachineDetailScreen file

class DashboardScreen extends StatelessWidget {
  // Example list of machines
  final List<Machine> machines = List.generate(
    9,
        (index) => Machine(
      name: "Machine ${index + 1}",
      imagePath: "assets/machine${index + 1}.jpg", // Ensure that these images exist
      quantityPrepared: (index + 1) * 10,
      quantityToDo: (index + 1) * 20,
      totalQuantity: (index + 1) * 30,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        backgroundColor: Colors.blue[900],
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.75,
        ),
        itemCount: machines.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the MachineDetailScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MachineDetailScreen(machine: machines[index]),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
              child: Column(
                children: [
                  // Your card content here, such as the image and machine name
                  Image.asset(machines[index].imagePath),
                  Text(machines[index].name),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
