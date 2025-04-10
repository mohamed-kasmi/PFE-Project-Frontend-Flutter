import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
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

  // Liste des rôles disponibles
  final Map<String, bool> roles = {
    "Responsable Planification": false,
    "Responsable Production": false,
  };

  void handleSubmit() async {
    String email = emailController.text;
    int matricule = int.tryParse(matriculeController.text) ?? 0;

    // Récupérer les rôles sélectionnés
    List<String> selectedRoles = roles.entries
        .where((entry) => entry.value) // Filtrer ceux qui sont cochés
        .map((entry) => entry.key) // Extraire le nom du rôle
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu semi-transparent
          Center(
            child: Container(
              width: 500,
              height: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Cadre avec opacité
                borderRadius: BorderRadius.circular(10), // Coins arrondis
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
                  // Email TextField
                  TextFieldWidget(
                    labelText: "Email",
                    controller: emailController,
                    icon: Icons.email,
                    iconColor: Colors.blue[900]!,  // Ensure the color is non-null
                    textColor: Colors.blue[900]!,  // Ensure the color is non-null
                  ),


                  SizedBox(height: 20),
                  // Matricule TextField
                  TextFieldWidget(
                    labelText: "Matricule",
                    controller: matriculeController,
                    icon: Icons.badge,
                    iconColor: Colors.blue[900]!,
                    textColor: Colors.blue[900]!,
                  ),
                  SizedBox(height: 20),
                  // Liste des Checkboxes avec le texte après
                  Column(
                    children: roles.keys.map((role) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Checkbox avant le texte
                          Checkbox(
                            value: roles[role],
                            onChanged: (bool? value) {
                              setState(() {
                                roles[role] = value ?? false;
                              });
                            },
                            activeColor: Colors.blue[900],
                            checkColor: Colors.white,
                          ),
                          // Texte du rôle
                          Text(
                            role,
                            style: TextStyle(color: Colors.blue[900]),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 30),
                  // Ajouter un Spacer pour pousser le bouton vers le bas
                  Spacer(),
                  // Bouton Ajouter Responsable avec taille réduite
                  Container(
                    width: double.infinity, // Largeur complète
                    height: 45, // Réduire la hauteur du bouton
                    child: ElevatedButton(
                      onPressed: handleSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Ajouter Responsable",
                        style: TextStyle(fontSize: 14,color: Colors.white), // Taille du texte plus petite
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
