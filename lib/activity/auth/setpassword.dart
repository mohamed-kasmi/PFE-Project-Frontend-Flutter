import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../api/apiuser.dart';

class SetPasswordPage extends StatefulWidget {
  final String? token;
  final String? email;

  SetPasswordPage({this.token, this.email});

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.token == null || widget.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid set password link.")),
        );
        return;
      }
      try {
        bool result = await Apiuser.setpass(widget.token!, widget.email!, _newPasswordController.text);
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password has been set successfully.')),
          );
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error setting password. Please try again.')),
          );
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error setting password. Please try again.")),
        );
        print("Error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"), // Set your background image here
                fit: BoxFit.cover, // Cover the screen with the image
              ),
            ),
          ),
          // Main content with semi-transparent background
          Center(
            child: Container(
              width: 500,
              height: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8), // Semi-transparent background
                borderRadius: BorderRadius.circular(10), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/bulgin.png', // Custom logo
                          height: 110, // Logo height
                          width: 150,  // Logo width
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Set Password for ${widget.email ?? 'Unknown'}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    // New Password TextField
                    TextFieldWidget(
                      labelText: "Password",
                      controller: _newPasswordController,
                      icon: Icons.lock,
                      obscureText: true,
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
                    ),
                    SizedBox(height: 20),
                    // Confirm Password TextField
                    TextFieldWidget(
                      labelText: "Confirm Password",
                      controller: _confirmPasswordController,
                      icon: Icons.lock_outline,
                      obscureText: true,
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
                    ),
                    SizedBox(height: 40),
                    // Set Password Button
                    ButtonWidget(
                      text: "Set Password",
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
