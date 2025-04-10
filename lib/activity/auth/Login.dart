import 'package:flutter/material.dart';
import '../../widget/Login_Elements/TextFieldWidget.dart';
import '../../widget/Login_Elements/LoginButtonWidget.dart';
import '../../widget/side_bar.dart';
import '../auth/Forget.dart';
import '../../api/apiuser.dart';
import '../home.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;

  Widget sizedBox(double height) => SizedBox(height: height);

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackbar("Please enter email and password");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      bool result = await Apiuser.auth(email, password);
      if (result) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        showSnackbar("Invalid email or password");
      }
    } catch (e) {
      showSnackbar("Login failed: ${e.toString()}");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image de fond
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover, // Ajuste l’image pour couvrir tout l’écran
              ),
            ),
          ),
          // Contenu principal avec effet de fond semi-transparent
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
                      mainAxisAlignment: MainAxisAlignment.start, // Push the logo to the right
                      children: [
                        Image.asset(
                          'assets/bulgin.png',
                          height: 110,  // Set the height of the logo image
                          width: 150,   // Set the width of the logo image
                        ),
                      ],
                    ),
                    sizedBox(20),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[900],
                        letterSpacing: 1.5,
                      ),
                    ),
                    sizedBox(40),
                    // Email TextField
                    TextFieldWidget(
                      labelText: "Enter your email",
                      obscureText: false,
                      controller: emailController,
                      icon: Icons.email,
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
                    ),
                    sizedBox(20),
                    // Password TextField
                    TextFieldWidget(
                      labelText: "Enter your password",
                      obscureText: true,
                      controller: passwordController,
                      icon: Icons.lock,
                      iconColor: Colors.blue[900]!,
                      textColor: Colors.blue[900]!,
                    ),
                    sizedBox(40),
                    // Login Button
                    isLoading
                        ? CircularProgressIndicator(color: Colors.blue[900])
                        : LoginButtonWidget(
                      text: "Login",
                      onPressed: handleLogin,
                    ),
                    sizedBox(15),
                    // Forgot Password link
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.blue[900], fontSize: 16),
                      ),
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
