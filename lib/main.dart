import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'src/pages/client/map/client_map_page.dart';
import 'src/pages/client/register/client_register_page.dart';
import 'src/pages/driver/map/driver_map_page.dart';
import 'src/pages/driver/register/driver_register_page.dart';
import 'src/pages/home/home_page.dart';
import 'src/pages/login/login_page.dart';
import 'src/utils/colors.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uber Clone',
      initialRoute: 'home',
      theme: ThemeData(
          fontFamily: 'NimbusSans',
          appBarTheme: const AppBarTheme(elevation: 0),
          primaryColor: utils.Colors.uberCloneColor),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => const LoginPage(),
        'client/register': (BuildContext context) => ClientRegisterPage(),
        'driver/register': (BuildContext context) => const DriverRegisterPage(),
        'driver/map': (BuildContext context) => const DriverMapPage(),
        'client/map': (BuildContext context) => ClientMapPage(),
      },
    );
  }
}
