import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement reset password logic (API Call)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password has been reset successfully')),
      );
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
                "Enter your new password",
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
