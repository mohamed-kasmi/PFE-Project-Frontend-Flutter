import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../home.dart';
import 'verification_code.dart';  // adjust the path if needed

import '../../widget/side_bar.dart';
import '../../api/apiuser.dart';
class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}
class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  void _submitForm() async {
    String email = emailController.text.trim();
    String? result = await Apiuser.forgotpass(email);

    if (result != null) {
      // Navigate to verification page with email passed
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerificationCodePage(email: result),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email does not exist or error occurred.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      drawer: SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: Colors.blue[900],
          ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/bulgin.png',
                      height: 110,
                      width: 150,
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Enter your email to reset your password",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue[900],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    TextFieldWidget(
                      labelText: "Email",
                      controller: emailController,
                      icon: Icons.email,
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
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
          ),
        ],
      ),
    );
  }
}