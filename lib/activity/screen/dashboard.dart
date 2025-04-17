import 'package:flutter/material.dart';
import '../../models/machine.dart';  // Import your Machine model
import 'machine_detail_screen.dart';  // Import your Machine detail screen

class DashboardScreen extends StatelessWidget {
  final List<Machine> machines = List.generate(
    9,
        (index) => Machine(
      name: "Machine ${index + 1}",
      imagePath: "assets/machine${index + 1}.jpg", // Make sure images exist
      quantityPrepared: (index + 1) * 10.0,  // Assuming this is a double
      quantityToDo: (index + 1) * 20.0,  // Assuming this is a double
      totalQuantity: (index + 1) * 30.0,
          image: 'assets/machine1.jpg',// Assuming this is a double
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.blue[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            final machine = machines[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MachineDetailScreen(machine: machine),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.asset(
                          machine.imagePath ?? 'assets/default_image.jpg',  // Use default if imagePath is null
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      machine.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
