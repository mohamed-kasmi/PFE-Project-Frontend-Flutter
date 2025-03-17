import 'package:flutter/material.dart';
import '../../widget/Login_Elements/TextFieldWidget.dart';
import '../../widget/Login_Elements/LoginButtonWidget.dart';
import '../../widget/side_bar.dart';
import '../auth/Forget.dart';
import '../../api/apiuser.dart';
import '../Home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void handleLogin() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter email and password")),
      );
      return;
    }

    try {
      bool result = await Apiuser.auth(email, password);
      if(result == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        ); // Navigate after login
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login failed")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock, size: 80, color: Colors.white),
              SizedBox(height: 20),
              Text(
                "Bulgin Login",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 40),
              TextFieldWidget(
                labelText: "Enter your email",
                obscureText: false,
                controller: emailController,
                icon: Icons.email,
              ),
              SizedBox(height: 20),
              TextFieldWidget(
                labelText: "Enter your password",
                obscureText: true,
                controller: passwordController,
                icon: Icons.lock,
              ),
              SizedBox(height: 40),
              LoginButtonWidget(
                text: "Login",
                onPressed: handleLogin, // Call handleLogin on button press
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
