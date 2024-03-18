
import 'package:adminmmas/providers/admin_provider.dart';
import 'package:adminmmas/views/CalendarScreen.dart';
import 'package:adminmmas/views/DashboardScreen.dart';
import 'package:adminmmas/views/NotificationScreen.dart';
import 'package:adminmmas/views/Planning.dart';
import 'package:adminmmas/views/PlanningScreen.dart';
import 'package:adminmmas/views/ReservationScreen.dart';
import 'package:adminmmas/views/SplashScreen.dart';
import 'package:adminmmas/views/imagetesteCropper.dart';
import 'package:adminmmas/views/login.dart';
import 'package:adminmmas/views/loginAdminMMAS.dart';
import 'package:adminmmas/views/resetPassword.dart';
import 'package:adminmmas/views/splscreeen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'dart:html';

void main() {
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MyApp()
  )
  );
  //runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        supportedLocales: [
          const Locale('fr'),
        ],
        locale: const Locale('fr'),
        /*localizationsDelegates: [
        ],
        supportedLocales: [
          const Locale('fr'),
        ],*/
      title: 'MMAS APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.orange,
      ),
      //debugShowMaterialGrid: false,
      home: SplashScreen(),
    //   routes: {
    // '/notification': (context) => NotificationsPage(),
    // },
    );
  }
}