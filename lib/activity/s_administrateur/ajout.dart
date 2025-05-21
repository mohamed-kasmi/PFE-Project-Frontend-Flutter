import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../widget/side_bar.dart';
import '../../api/apiuser.dart';
import '../../service/SharedPreferences/shared_pref_service.dart';
import '../../widget/notifications.dart';

class AjoutPage extends StatefulWidget {
  @override
  _AjoutPageState createState() => _AjoutPageState();
}

class _AjoutPageState extends State<AjoutPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController matriculeController = TextEditingController();
  String? userEmail;

  @override
  void initState() {
    super.initState();
    loadEmail();
  }
  Future<void> loadEmail() async {
    final email = await SharedPrefService.getEmail();
    if (email != null && email.isNotEmpty) {
      setState(() {
        userEmail = email;
      });
    }
  }

  // Internal role mapping
  final Map<String, String> roles = {
    "Responsible Planning": "planification",
    "Responsible Production": "production",
  };

  // Separate checkbox state map
  final Map<String, bool> roleChecks = {
    "Responsible Planning": false,
    "Responsible Production": false,
  };

  void handleSubmit() async {
    String email = emailController.text;
    int matricule = int.tryParse(matriculeController.text) ?? 0;

    // Get selected internal role values
    List<String> selectedRoles = roleChecks.entries
        .where((entry) => entry.value)
        .map((entry) => roles[entry.key]!)
        .toList();

    if (selectedRoles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one role.")),
      );
      return;
    }

    try {
      bool result = await Apiuser.adduser(matricule, email, selectedRoles.join(", "));
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User has been added. Please check the mail box.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User already exists!")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Add user failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Add Users",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
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
        actions:[
          if (userEmail != null && userEmail!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: NotificationIcon(userEmail: userEmail!),
            ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: 500,
              height: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Column(
                children: [
                  TextFieldWidget(
                    labelText: "Email",
                    controller: emailController,
                    icon: Icons.email,
                    iconColor: Colors.blue[900]!,
                    textColor: Colors.blue[900]!,
                  ),
                  SizedBox(height: 20),
                  TextFieldWidget(
                    labelText: "Employee number",
                    controller: matriculeController,
                    icon: Icons.badge,
                    iconColor: Colors.blue[900]!,
                    textColor: Colors.blue[900]!,
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: roleChecks.keys.map((role) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: roleChecks[role],
                            onChanged: (bool? value) {
                              setState(() {
                                roleChecks[role] = value ?? false;
                              });
                            },
                            activeColor: Colors.blue[900],
                            checkColor: Colors.white,
                          ),
                          Text(
                            role,
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  Spacer(),
                  Container(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Add Responsible",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
