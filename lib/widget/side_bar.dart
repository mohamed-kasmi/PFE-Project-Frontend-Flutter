import 'package:flutter/material.dart';
import 'package:pdcs_frontend/activity/auth/Login.dart';
import 'package:pdcs_frontend/activity/s_administrateur/users.dart';
import '../activity/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _role = prefs.getString('role') ?? ''; // Ensure state updates properly
    });
  }
  Future<void> _setRole() async {
    final prefs = await SharedPreferences.getInstance();
      await prefs.setString('role','admin'); // Ensure state updates properly

  }
  Future<void> _defaultRole() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role',''); // Ensure state updates properly

  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue[900]),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.account_circle, size: 60, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "Welcome!",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Text(
                  "user@example.com",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Conditionally Render Menu Items Based on Role
          if (_role == 'admin') ..._adminMenu(context)
          else if (_role == 'planification') ..._planificationMenu(context)
          else if (_role == 'production') ..._productionMenu(context)
            else ..._defaultMenu(context)
        ],
      ),
    );
  }

  // Define Menu Lists Separately for Readability
  List<Widget> _adminMenu(BuildContext context) {
    return [
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
      ),
      ListTile(
        leading: Icon(Icons.person),
        title: Text('Users'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => UsersPage())),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Production'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: Icon(Icons.stop),
        title: Text('Stop'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: Icon(Icons.next_plan),
        title: Text('Planification'),
        onTap: () => Navigator.pop(context),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () {
          _defaultRole(); // Call the function first
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); // Then navigate
        },
      ),
    ];
  }

  List<Widget> _planificationMenu(BuildContext context) {
    return [
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
      ),
      ListTile(
        leading: Icon(Icons.next_plan),
        title: Text('Planification'),
        onTap: () => Navigator.pop(context),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () {
          _defaultRole(); // Call the function first
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); // Then navigate
        },
      ),
    ];
  }

  List<Widget> _productionMenu(BuildContext context) {
    return [
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Production'),
        onTap: () => Navigator.pop(context),
      ),
      ListTile(
        leading: Icon(Icons.stop),
        title: Text('Stop'),
        onTap: () => Navigator.pop(context),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.logout),
        title: Text('Logout'),
        onTap: () {
          _defaultRole(); // Call the function first
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())); // Then navigate
        },
      ),
    ];
  }
  List<Widget> _defaultMenu(BuildContext context) {
    return [
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Home'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage())),
      ),
      Divider(),
      ListTile(
        leading: Icon(Icons.login),
        title: Text('LogIn'),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Login())),
      ),
    ];
  }
}
