import 'package:flutter/material.dart';
import '../widget/side_bar.dart'; // Ensure that this file exists
import 'screen/dashboard.dart';  // The dashboard screen will be defined separately
import '../models/machine.dart'; // Import the Machine class
import 'package:percent_indicator/percent_indicator.dart'; // Import the package
class HomePage extends StatelessWidget {
  static final List<String> imagePaths = [
    "assets/machine1.jpeg",
    "assets/machine2.jpg",
    "assets/machine3.jpg",
    "assets/machine1.jpeg",
    "assets/machine2.jpg",
    "assets/machine3.jpg",
    "assets/machine1.jpeg",
    "assets/machine2.jpg",
    "assets/machine3.jpg",
  ];

  final List<Machine> machines = List.generate(
    9,
        (index) => Machine(
      name: "Machine ${index + 1}",
      imagePath: imagePaths[index],
      quantityPrepared: (index + 1) * 10,
      quantityToDo: (index + 1) * 20,
      totalQuantity: (index + 1) * 40,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      drawer: SideBar(), // Ensure that the SideBar widget is implemented properly
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5, // 3 machines per row (adjust as needed)
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // Adjust this value for card size
          ),
          itemCount: machines.length,
          itemBuilder: (context, index) {
            return MachineCard(machine: machines[index]);
          },
        ),
      ),
    );
  }
}

class MachineCard extends StatelessWidget {
  final Machine machine;

  const MachineCard({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progress = machine.quantityPrepared / machine.totalQuantity; // Calculate progress
    double percentage = progress * 100; // Calculate percentage

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MachineDashboard(machine: machine), // This screen needs to be defined
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    machine.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Text(
                machine.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("Prepared: ${machine.quantityPrepared}", style: TextStyle(fontSize: 14)),
              Text("To Do: ${machine.quantityToDo}", style: TextStyle(fontSize: 14)),
              Text("Total: ${machine.totalQuantity}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),

              // Add LinearProgressIndicator with black border and thicker progress bar
              SizedBox(height: 10), // Add some space between text and progress bar
              Stack(
                children: [
                  // Outer container with thinner border
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1), // Thin black border
                      borderRadius: BorderRadius.circular(8), // Rounded corners for the border
                    ),
                    child: Container(
                      height: 12, // Increased thickness of the progress bar
                      child: LinearProgressIndicator(
                        value: progress, // Set the progress value between 0.0 and 1.0
                        backgroundColor: Colors.grey[200], // Background color of the progress bar
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // Set to blue color
                      ),
                    ),
                  ),
                  // Centered text for percentage inside the bar
                  Center(
                    child: Text(
                      "${percentage.toStringAsFixed(0)}%", // Show percentage
                      style: TextStyle(
                        color: Colors.black, // Text color set to black
                        fontWeight: FontWeight.normal, // Remove bold styling
                        fontSize: 10, // Reduced font size (smaller)
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class MachineDashboard extends StatelessWidget {
  final Machine machine;

  const MachineDashboard({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Calculate progress
    double progress = machine.quantityPrepared / machine.totalQuantity;

    return Scaffold(
      appBar: AppBar(
        title: Text(machine.name),
        backgroundColor: Colors.blue[900],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 12.0,
              percent: progress,  // Use the progress here
              center: Text("${(progress * 100).toStringAsFixed(1)}%"),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: Colors.blue,
              backgroundColor: Colors.grey[300] ?? Colors.grey,
            ),
            SizedBox(height: 20),
            Text(
              "Machine: ${machine.name}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text("Prepared: ${machine.quantityPrepared}"),
            Text("To Do: ${machine.quantityToDo}"),
            Text("Total: ${machine.totalQuantity}"),
          ],
        ),
      ),
    );
  }
}

// Sample Machine class
class Machine {
  final String name;
  final String imagePath;
  final int quantityPrepared;
  final int quantityToDo;
  final int totalQuantity;

  Machine({
    required this.name,
    required this.imagePath,
    required this.quantityPrepared,
    required this.quantityToDo,
    required this.totalQuantity,
  });
}