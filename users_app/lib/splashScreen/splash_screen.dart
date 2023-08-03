import 'dart:async';
import 'package:flutter/material.dart';
import 'package:users_app/authentication/login_screen.dart';

import '../assistants/assistant_methods.dart';
import '../global/global.dart';
import '../mainScreens/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    fAuth.currentUser != null
        ? AssistantMethods.readCurrentOnlineUserInfo()
        : null;

    Timer(const Duration(seconds: 3), () async {
      if (await fAuth.currentUser != null) {
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/splash.jpg'),
                fit: BoxFit.cover,
                ),
          ),
          child: const Center(
            child: Text(
              '',
              style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
