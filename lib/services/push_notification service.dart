// import 'package:firebase_messaging/firebase_messaging.dart';

// class PushNotificationService {
//   final FirebaseMessaging _fcm;

//   PushNotificationService(this._fcm);

//   Future initialise() async {
//     // if (Platform.isIOS) {
//     //   _fcm.requestNotificationPermissions(IosNotificationSettings());
//     // }

//     // If you want to test the push notification locally,
//     // you need to get the token and input to the Firebase console
//     // https://console.firebase.google.com/project/YOUR_PROJECT_ID/notification/compose
//     String? token = await _fcm.getToken();
//     print("FirebaseMessaging token: $token");

//     _fcm.configure(
//       onMessage: (Map<String, dynamic> message) async {
//         print("onMessage: $message");
//       },
//       onLaunch: (Map<String, dynamic> message) async {
//         print("onLaunch: $message");
//       },
//       onResume: (Map<String, dynamic> message) async {
//         print("onResume: $message");
//       },
//     );
//   }
// }