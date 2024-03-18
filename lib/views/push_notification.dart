//
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
//
// class PushNotificationsManager {
//
//   PushNotificationsManager._();
//
//   factory PushNotificationsManager() => _instance;
//
//   static final PushNotificationsManager _instance = PushNotificationsManager._();
//
//   final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
//   bool _initialized = false;
//
//   Future<void> init() async {
//     if (!_initialized) {
//       // For iOS request permission first.
//       _firebaseMessaging.requestNotificationPermissions();
//       _firebaseMessaging.configure();
//
//       // For testing purposes print the Firebase Messaging token
//       String token = await _firebaseMessaging.getToken();
//       print("FirebaseMessaging token: $token");
//
//       _initialized = true;
//     }
//   }
// }
//
//
//
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Push Notification Demo',
//       theme: ThemeData(
//
//         primarySwatch: Colors.blue,
//
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(title: 'Flutter Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({ Key? key, required this.title}) : super(key: key);
//
//
//
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Scaffold(
//       appBar: AppBar(
//
//         title: Text(widget.title),
//       ),
//       body: Center(
//
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
