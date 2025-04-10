import 'package:flutter/material.dart';
import '../../widget/TextFieldWidget.dart';
import '../../widget/ButtonWidget.dart';
import '../home.dart';
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
    String email = emailController.text;
    try {
      bool response = await Apiuser.forgotpass(email);
      if (response == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset link sent to your email.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email does not exist.')),
        );
      }
    } catch (e) {
      print("$e");
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
          // Background color
          Container(
            color: Colors.blue[900], // Background color, adjust if you want an image
          ),
          // Main content with a semi-transparent container
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
                    Image.asset(
                      'assets/bulgin.png', // Custom logo instead of lock icon
                      height: 110, // Logo height
                      width: 150,  // Logo width
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
                    // Email TextField with email icon
                    TextFieldWidget(
                      labelText: "Email",
                      controller: emailController,
                      icon: Icons.email, // Email icon added
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
                    ),
                    SizedBox(height: 20),
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
        ],
      ),
    );
  }
}
