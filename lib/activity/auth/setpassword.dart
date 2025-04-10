import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../api/apiuser.dart';

class SetPasswordPage extends StatefulWidget {
  final String verificationId;

  SetPasswordPage({required this.verificationId});

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends State<SetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? email;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadVerificationData();
  }

  Future<void> _loadVerificationData() async {
    final result = await Apiuser.fetchTokenAndEmail(widget.verificationId);
    if (result != null) {
      setState(() {
        email = result['email'];
        token = result['token'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid or expired verification link.")),
      );
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (token == null || email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Verification info missing.")),
        );
        return;
      }

      bool result = await Apiuser.setpass(token!, email!, _newPasswordController.text);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      appBar: AppBar(backgroundColor: Colors.blue[900]),
      body: email == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Set Password for $email",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Password",
                obscureText: true,
                controller: _newPasswordController,
                icon: Icons.lock,
                iconColor: Colors.white,
                textColor: Colors.white,
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Confirm Password",
                obscureText: true,
                controller: _confirmPasswordController,
                icon: Icons.lock_outline,
                iconColor: Colors.white,
                textColor: Colors.white,
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

