import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:houseskape/chat_screen.dart';
import 'package:houseskape/dashboard_screen.dart';
import 'package:houseskape/home_screen.dart';
import 'package:houseskape/map_screen.dart';
import 'package:houseskape/notifiers/property_notifier.dart';
import 'package:houseskape/profile_screen.dart';
import 'package:houseskape/registration_screen.dart';
import 'package:houseskape/login_screen.dart';
import 'package:houseskape/saved_screen.dart';
import 'package:houseskape/listings_screen.dart';
import 'package:houseskape/property_details_screen.dart';
import 'package:houseskape/search_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Initialize Mapbox SDK access token
  MapboxOptions.setAccessToken(const String.fromEnvironment('ACCESS_TOKEN'));
  // await migratePropertiesToTopLevel();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });
  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PropertyNotifier(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'DM_Sans',
          scaffoldBackgroundColor: const Color(0xfffcf9f4),
          // primaryColor: const Color(0xff1b3359),
          textTheme: const TextTheme(
            displayLarge: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
            titleLarge: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.normal,
                color: Color(0xFF636363)),
            bodyMedium: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (ctx) => const LoginScreen(),
          '/register': (ctx) => const RegistrationScreen(),
          '/dashboard': (ctx) => const DashboardScreen(),
          '/home': (ctx) => const HomeScreen(),
          '/saved': (ctx) => const SavedScreen(),
          '/chat': (ctx) => const ChatScreen(),
          '/profile': (ctx) => const ProfileScreen(),
          '/map': (ctx) => const MapScreen(),
          '/listings': (ctx) => const ListingsScreen(),
          '/property-details': (ctx) => const PropertyDetailsScreen(),
          '/search': (ctx) => const SearchScreen(),
          // '/add-property-step1':(ctx) =>  Step1Screen(),
          // '/add-property-step2':(ctx) => const Step2Screen(),
        });
  }
}
