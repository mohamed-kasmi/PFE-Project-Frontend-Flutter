import 'package:flutter/material.dart';
import 'package:pdcs_frontend/activity/home.dart';
import 'activity/auth/Login.dart';
import 'activity/auth/Forget.dart';
import 'activity/auth/reset.dart';
import 'activity/auth/setpassword.dart';
import 'activity/s_administrateur/users.dart';
import 'activity/s_administrateur/ajout.dart';
import 'activity/screen/dashboard.dart';
import 'activity/rs_production/productionDashbord.dart';
import 'activity/rs_production/pro.dart';
import 'activity/rs_planification/planification.dart';
import 'activity/rs_production/Trs.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    onGenerateRoute: (settings) {
      Uri uri = Uri.parse(settings.name!);
      if (uri.path == '/reset-password') {
        String? verificationId = uri.queryParameters['vid'];
        if (verificationId != null) {
          return MaterialPageRoute(
            builder: (context) => ResetPasswordPage(verificationId: verificationId),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Invalid link.')),
            ),
          );
        }
      }
      if (uri.path == '/set-password') {
        String? verificationId = uri.queryParameters['vid'];
        if (verificationId != null) {
          return MaterialPageRoute(
            builder: (context) => SetPasswordPage(verificationId: verificationId),
          );
        } else {
          return MaterialPageRoute(
            builder: (context) => Scaffold(
              body: Center(child: Text('Invalid link.')),
            ),
          );
        }
      }
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => TrsPage ());
        case '/login':
          return MaterialPageRoute(builder: (context) => Login());
        case '/users':
          return MaterialPageRoute(builder: (context) => UsersPage());
        default:
          return MaterialPageRoute(builder: (context) => HomePage());
      }
    },
  ));
}
