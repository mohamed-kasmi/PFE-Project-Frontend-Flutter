import 'package:flutter/material.dart';
import 'package:pdcs_frontend/activity/Home.dart';
import 'activity/auth/Login.dart';
import 'activity/auth/Forget.dart';
import 'activity/auth/reset.dart';
import 'activity/s_administrateur/ajout.dart';

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
