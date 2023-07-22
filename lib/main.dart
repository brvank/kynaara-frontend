import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kynaara_frontend/data/repositories/session_manager.dart';
import 'package:kynaara_frontend/presentation/screens/home_screen.dart';
import 'package:kynaara_frontend/presentation/screens/login_screen.dart';
import 'package:kynaara_frontend/utils/configurations/route_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SessionManager sessionManager = SessionManager();
  bool loggedIn = false;
  SharedPreferences? sharedPreferences;

  @override
  void initState() {
    super.initState();

    checkForUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          fontFamily: GoogleFonts.montserrat().fontFamily),
      home: loggedIn ? const HomeScreen() : const LoginScreen(),
    );
  }

  void checkForUserSession() async {
    sharedPreferences = await SharedPreferences.getInstance();

    setState(() {
      loggedIn =
          sessionManager.getToken(sharedPreferences!).isEmpty ? false : true;
    });
  }
}
