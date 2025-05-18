import 'package:flutter/material.dart';
import 'dart:async';
import 'reset.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../widget/ButtonWidget.dart';

// Ensure this file exists and is correctly linked

class VerificationCodePage extends StatefulWidget {
  final String email;
  VerificationCodePage({required this.email, Key? key}) : super(key: key);
  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  final TextEditingController _codeController = TextEditingController();
  late Timer _timer;
  int _remainingSeconds = 600; // 10 minutes
  bool isCodeValid = false;

  @override
  void initState() {
    super.initState();
    _startTimer(); // Start the timer on page load
    _codeController.addListener(() {
      final code = _codeController.text;
      final isValid = RegExp(r'^\d{6}$').hasMatch(code);
      if (isValid != isCodeValid) {
        setState(() {
          isCodeValid = isValid;
        });
      }
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _codeController.dispose();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}';
  }

  void _submitCode() async {
    final code = _codeController.text.trim();

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/auth/verify_code/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': widget.email,
        'code': code,
      }),
    );

    if (response.statusCode == 200) {
      // Code verified, navigate to reset password page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordPage(email: widget.email),
        ),
      );
      print(widget.email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Code incorrect or expired.")),
      );
      print(widget.email);
      print(code);
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
                    "Entrez le code de vérification",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: TextStyle(color: Colors.blue[900]),
                    decoration: InputDecoration(
                      labelText: "Code",
                      labelStyle: TextStyle(color: Colors.blue[900]),
                      counterText: "",
                      prefixIcon: Icon(Icons.numbers, color: Colors.blue[900]),
                      suffixIcon: isCodeValid
                          ? Icon(Icons.verified, color: Colors.blue[900])
                          : null,
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Colors.blue[900]!, width: 2),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Temps restant : ${_formatTime(_remainingSeconds)}",
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  ButtonWidget(
                    text: "Valider le code",
                    onPressed: _submitCode,
                    height: 50,
                    width: double.infinity,
                    textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
