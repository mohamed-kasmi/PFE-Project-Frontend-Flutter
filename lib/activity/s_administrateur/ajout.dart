import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/RoleSelectionWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../widget/side_bar.dart';
class AjoutPage extends StatefulWidget {
  @override
  _AjoutPageState createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  String _selectedRole = "";  // Default role

  void handleSubmit() {
    String email = emailController.text;
    String matricule = matriculeController.text;

    // Handle form submission
    print("Email: $email, Matricule: $matricule, Role: $_selectedRole");
  }

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
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Email TextField using TextFieldWidget
              TextFieldWidget(
                labelText: "Email",
                controller: emailController,
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              // Matricule TextField using TextFieldWidget
              TextFieldWidget(
                labelText: "Matricule",
                controller: matriculeController,
                icon: Icons.badge,
              ),
              SizedBox(height: 20),
              // Role Radio buttons using RoleSelectionWidget
              RoleSelectionWidget(
                value: "Responsable Planification",
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              RoleSelectionWidget(
                value: "Responsable Production",
                groupValue: _selectedRole,

                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                  });
                },
              ),
              SizedBox(height: 30),
              // Submit Button using ButtonWidget
              ButtonWidget(
                text: "Ajouter Responsable",

                onPressed: handleSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
