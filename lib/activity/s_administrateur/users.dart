import 'package:flutter/material.dart';
import '../../api/apiuser.dart';
import '../../models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    List<User> fetchedUsers = await Apiuser.getusers();
    setState(() {
      users = fetchedUsers;
    });
  }

  // Show Delete Confirmation Dialog
  void _showDeleteConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Delete"),
        content: Text("Are you sure you want to delete ${user.email}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              await _deleteUser(user.id);
            },
            child: Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Delete User
  Future<void> _deleteUser(int id) async {
    bool isDeleted = await Apiuser.deleteuser(id);
    if (isDeleted) {
      setState(() {
        users.removeWhere((user) => user.id == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User deleted successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete user")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Users")),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].email),
            subtitle: Text("Matricule: ${users[index].matricule}, Role: ${users[index].role}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmationDialog(users[index]),
            ),
          );
        },
      ),
    );
  }
}
