import 'package:flutter/material.dart';
import '../widget/side_bar.dart';
import 'screen/dashboard.dart';
import '../models/machine.dart';
import 'package:percent_indicator/percent_indicator.dart';
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
            crossAxisCount: 5,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
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
    double progress = machine.quantityPrepared / machine.totalQuantity;
    double percentage = progress * 100;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MachineDashboard(machine: machine),
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
              SizedBox(height: 10),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Container(
                      height: 12,
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      "${percentage.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
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
              percent: progress,
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