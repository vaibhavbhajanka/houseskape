import 'package:flutter/material.dart';
import 'package:houseskape/registration_screen.dart';
import 'package:houseskape/login_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: '/login',
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/register' : (ctx) => const RegistrationScreen(),
        }
    );
  }
}
