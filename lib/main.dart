import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/home_screen.dart';
import 'package:houseskape/registration_screen.dart';
import 'package:houseskape/login_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
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
        initialRoute: '/login',
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegistrationScreen(),
          '/home': (ctx) => const HomeScreen(),
        });
  }
}
