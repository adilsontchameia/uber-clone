import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber_clone/src/pages/home/home_page.dart';
import 'package:uber_clone/src/pages/login/login_page.dart';
import 'package:uber_clone/src/pages/register/register_page.dart';
import 'package:uber_clone/src/utils/Colors.dart' as utils;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Uber Clone",
      initialRoute: 'home',
      theme: ThemeData(
        fontFamily: 'NimbusSans',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: utils.Colors.uberCloneColor,
        ),
      ),
      routes: {
        'home': (BuildContext context) => HomePage(),
        'login': (BuildContext context) => const LoginPage(),
        'register': (BuildContext context) => const RegisterPage(),
      },
    );
  }
}
