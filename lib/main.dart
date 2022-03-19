import 'package:flutter/material.dart';
import 'package:houseskape/registration_screen.dart';
import 'package:houseskape/login_screen.dart';
import './splash_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

        routes: {
          '/': (ctx) => const SplashScreen1(),
          '/login': (ctx) => const LoginScreen(),
          '/register' : (ctx) => const RegistrationScreen(),
        }
    );
  }
}
