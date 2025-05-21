import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../../api/apiuser.dart';
import '../../service/SharedPreferences/shared_pref_service.dart';

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
    _loademail();
  }

  Future<void> _loademail() async {
    if (widget.email != null) {
      setState(() {
        email = widget.email;
      });
    } else {
      String? storedEmail = await SharedPrefService.getEmail();
      setState(() {
        email = storedEmail;
      });
    }
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
      extendBodyBehindAppBar: true, // Allows body content to go under AppBar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent AppBar
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            "assets/background.jpg",
            fit: BoxFit.cover,
          ),
          // Main content with semi-transparent background
          Center(
            child: Container(
              width: 500,
              height: 600,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
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
                            'assets/bulgin.png',
                            height: 110,
                            width: 150,
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
                      TextFieldWidget(
                        labelText: "New Password",
                        controller: _newPasswordController,
                        icon: Icons.lock,
                        obscureText: !_isNewPasswordVisible,
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
                      TextFieldWidget(
                        labelText: "Confirm Password",
                        controller: _confirmPasswordController,
                        icon: Icons.lock_outline,
                        obscureText: !_isConfirmPasswordVisible,
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
