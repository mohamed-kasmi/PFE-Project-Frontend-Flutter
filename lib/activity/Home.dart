import 'package:flutter/material.dart';
import '../widget/side_bar.dart';

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

  final List<Machine> machines = List.generate(9, (index) => Machine(
    name: "Machine ${index + 1}",
    imagePath: imagePaths[index], // Now it works!
    quantityPrepared: (index + 1) * 10,
    quantityToDo: (index + 1) * 20,
    totalQuantity: (index + 1) * 30,
  ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      drawer: SideBar(),
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
            crossAxisCount: 3, // 3 machines per row
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75, // Adjust for better aspect ratio
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

class MachineCard extends StatelessWidget {
  final Machine machine;

  const MachineCard({Key? key, required this.machine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
            Text("Prepared: ${machine.quantityPrepared}",
                style: TextStyle(fontSize: 14)),
            Text("To Do: ${machine.quantityToDo}", style: TextStyle(fontSize: 14)),
            Text("Total: ${machine.totalQuantity}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
