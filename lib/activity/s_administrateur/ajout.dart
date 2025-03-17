import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/RoleSelectionWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../widget/side_bar.dart';
import '../../api/apiuser.dart';
class AjoutPage extends StatefulWidget {
  @override
  _AjoutPageState createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  String _selectedRole = "";
  String _Role = "";

  void handleSubmit() async{
    String email = emailController.text;
    int matricule = int.parse(matriculeController.text);
    if (_selectedRole == '') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a role.")),
      );
      return;
    }else{
      try{
        bool result = await Apiuser.adduser(matricule, email, _Role);
        if(result == true){
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User has been added. Please check the mail box.")),
          );
        }else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("User already exist !")),
          );
        }
      }catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Add user failed: $e")),
        );
      }
    }


    print("Email: $email, Matricule: $matricule, Role: $_Role");
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
                iconColor: Colors.white, // Set icon color to white
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
              // Matricule TextField using TextFieldWidget
              TextFieldWidget(
                labelText: "Matricule",
                controller: matriculeController,
                icon: Icons.badge,
                iconColor: Colors.white, // Set icon color to white
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
              // Role Radio buttons using RoleSelectionWidget
              RoleSelectionWidget(
                value: "Responsable Planification",
                groupValue: _selectedRole,
                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    _Role = "planification";
                  });
                },
              ),
              RoleSelectionWidget(
                value: "Responsable Production",
                groupValue: _selectedRole,

                onChanged: (value) {
                  setState(() {
                    _selectedRole = value!;
                    _Role = "production";
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
