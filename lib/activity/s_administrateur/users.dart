import 'package:flutter/material.dart';
import '../../api/apiuser.dart';
import '../../models/user.dart';
import 'ajout.dart';
import '../../widget/side_bar.dart';
import '../../service/SharedPreferences/shared_pref_service.dart';
import '../../widget/notifications.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _loadUsers();
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

  Future<void> _loadUsers() async {
    List<User> fetchedUsers = await Apiuser.getusers();
    setState(() {
      users = fetchedUsers;
    });

  }

  void _showDeleteConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${user.email}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteUser(user.id);
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(int id) async {
    bool response = await Apiuser.deleteuser(id);

    if (response) {
      setState(() {
        users.removeWhere((user) => user.id == id);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Échec de la suppression de l\'utilisateur.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text(
          "Users",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        iconTheme: IconThemeData(color: Colors.white),
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
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenu semi-transparent pour la lisibilité
          Center(
            child: Container(
              width: 500,
              height: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Cadre semi-transparent
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
                  // Liste des utilisateurs
                  Expanded(
                    child: users.isEmpty
                        ? Center(
                      child: Text(
                        "No users available",
                        style: TextStyle(color: Colors.blue[900], fontSize: 18),
                      ),
                    )
                        : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Card(
                          color: Colors.blue[900], // Assombrir la carte
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(
                              user.email,
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "Matricule: ${user.matricule}\nRole: ${user.role}",
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _showDeleteConfirmationDialog(user),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Add Button inside the card
                  Container(
                    alignment: Alignment.bottomCenter,
                    margin: EdgeInsets.only(top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AjoutPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[900],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, color: Colors.white),
                          SizedBox(width: 8),
                          Text("Add User", style: TextStyle(color: Colors.white)),
                        ],
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
