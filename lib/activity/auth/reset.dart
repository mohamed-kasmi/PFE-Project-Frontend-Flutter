import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../api/apiuser.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? token;
  final String? email;

  ResetPasswordPage({this.token, this.email}); // Accept parameters

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (widget.token == null || widget.email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid reset link.")),
        );
        return;
      }
      try {
        await Apiuser.restpass(widget.token!, widget.email!, _newPasswordController.text);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password has been reset successfully')),
        );

        // Navigate to the login page after success
        Navigator.pushReplacementNamed(context, '/login');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error resetting password. Please try again.")),
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
                "Reset Password for ${widget.email ?? 'Unknown'}",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "New Password",
                controller: _newPasswordController,
                icon: Icons.lock,
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Confirm Password",
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
              ),
              SizedBox(height: 20),
              ButtonWidget(
                text: "Reset Password",
                onPressed: _submitForm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
