import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import './login_screen.dart';


class SplashScreen1 extends StatefulWidget {
  const SplashScreen1({Key? key}) : super(key: key);

  @override
  State<SplashScreen1> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen1> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 6,
      navigateAfterSeconds: const LoginScreen(),

      image: Image.asset('assets/images/logo.png', fit: BoxFit.cover,),
      //loadingText: Text("Loading"),
      photoSize: 100.0,
      //loaderColor: Colors.blue,
    );
  }
  }