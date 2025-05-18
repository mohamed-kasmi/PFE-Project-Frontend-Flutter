import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../api/apiuser.dart';

import 'verification_code.dart';

class ResetPasswordPage extends StatefulWidget {
  final String? email;

  ResetPasswordPage({this.email, Key? key}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? email;

  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
      email = widget.email;
  }



  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (email == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid reset link.")),
        );
        return;
      }
      try {
        bool response = await Apiuser.restpass( email!, _newPasswordController.text);
        if (response == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Password has been reset successfully.')),
          );

          // Navigate to the login page after success
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Link has been expired.')),
          );
        }
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
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
                child: Form(
                  key: _formKey,
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
                        "Reset Password for ${email ?? 'Unknown'}",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      // New Password TextField with visibility toggle
                      TextFieldWidget(
                        labelText: "New Password",
                        controller: _newPasswordController,
                        icon: Icons.lock,
                        obscureText: !_isNewPasswordVisible, // Toggle visibility
                        iconColor: Colors.blue[900]!,
                        textColor: Colors.blue[900]!,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[900],
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      // Confirm Password TextField with visibility toggle
                      TextFieldWidget(
                        labelText: "Confirm Password",
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline,
                        obscureText: !_isConfirmPasswordVisible, // Toggle visibility
                        iconColor: Colors.blue[900]!,
                        textColor: Colors.blue[900]!,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[900],
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      // Reset Password Button
                      ButtonWidget(
                        text: "Reset Password",
                        onPressed: _submitForm,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
