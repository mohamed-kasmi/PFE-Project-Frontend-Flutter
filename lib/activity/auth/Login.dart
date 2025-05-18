import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../../widget/Login_Elements/LoginButtonWidget.dart';
import '../../widget/side_bar.dart';
import '../auth/Forget.dart';
import '../../api/apiuser.dart';
import '../home.dart';
import '../../firebase/firebase_initializer.dart';
import '../../api/apinotification.dart';
import 'reset.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}
class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  bool _isPasswordVisible = false;
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
      final result = await Apiuser.auth(email, password);
      if (result['success'] == true) {
        bool firstLogin = result['firstlogin'];

        if (firstLogin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordPage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
          await FirebaseInitializer.initialize();
          String? fcmToken = await FirebaseMessaging.instance.getToken();

          if (fcmToken != null) {
            await ApiNotification.sendFcmToken(fcmToken);
          } else {
            print("Failed to retrieve FCM token");
          }
        }
        
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
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
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
                    TextField(
                      controller: emailController,
                      obscureText: false,
                      style: TextStyle(color: Colors.blue[900]),
                      decoration: InputDecoration(
                        labelText: "Enter your email",
                        labelStyle: TextStyle(color: Colors.blue[900]),
                        prefixIcon: Icon(Icons.email, color: Colors.blue[900]),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    sizedBox(20),
                    TextField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      style: TextStyle(color: Colors.blue[900]),
                      decoration: InputDecoration(
                        labelText: "Enter your password",
                        labelStyle: TextStyle(color: Colors.blue[900]),
                        prefixIcon: Icon(Icons.lock, color: Colors.blue[900]),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue[900],
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    sizedBox(40),
                    isLoading
                        ? CircularProgressIndicator(color: Colors.blue[900])
                        : LoginButtonWidget(
                      text: "Login",
                      onPressed: handleLogin,
                    ),
                    sizedBox(15),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
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