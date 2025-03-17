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
      backgroundColor: Colors.blue[900],
      appBar: AppBar(backgroundColor: Colors.blue[900]),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Set Password for ${widget.email ?? 'Unknown'}",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Password",
                obscureText: true,
                controller: _newPasswordController,
                icon: Icons.lock,
                iconColor: Colors.white, // Set icon color to white
                textColor: Colors.white, // Set text color to white
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Confirm Password",
                obscureText: true,
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
                iconColor: Colors.white, // Set icon color to white
                textColor: Colors.white, // Set text color to white
              ),
              SizedBox(height: 20),
              ButtonWidget(
                text: "Set Password",
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
