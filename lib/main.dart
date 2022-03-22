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
        theme: ThemeData(
          // Define the default brightness and colors.
          //brightness: Brightness.dark,
          //primaryColor: Colors.lightBlue[800],

          // Define the default font family.
          fontFamily: 'DM_Sans',

          textTheme: const TextTheme(
            headline1: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            headline6: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFF636363)),
            bodyText2: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        routes: {
          '/': (ctx) => const SplashScreen1(),
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegistrationScreen(),
        });
  }
}
