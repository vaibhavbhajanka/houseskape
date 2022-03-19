import 'package:flutter/material.dart';
import 'package:houseskape/registration_screen.dart';
import 'package:houseskape/login_screen.dart';

void main() {
  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: RegistrationScreen(),
    );
  }
}
