import 'dart:async';

import 'package:flutter/material.dart';
import 'package:traindrivers_app/authentication/login_screen.dart';
import 'package:traindrivers_app/authentication/signup_screen.dart';
import 'package:traindrivers_app/mainScreens/main_screen.dart';

import '../global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
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
    return Material(
      child: Container(
          color: Colors.white,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("images/traindriver.png"),
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Train Driver app",
                style: TextStyle(
                    fontSize: 27,
                    color: Color(0xFF2196F3),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ))),
    );
  }
}
