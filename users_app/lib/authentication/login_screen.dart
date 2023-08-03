import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/signup_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (passwordTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
    } else {
      LoginUserNow();
    }
  }

  LoginUserNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference driversRef =
          FirebaseDatabase.instance.ref().child("users");
      driversRef.child(firebaseUser.uid).once().then((driverKey) {
        final snap = driverKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: "Logging Successful.");
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        } else {
          Fluttertoast.showToast(msg: "No record exist with this email!");
          fAuth.signOut();
          Navigator.push(context,
              MaterialPageRoute(builder: (c) => const MySplashScreen()));
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Can't login right now.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset("images/login.jpg"),
              ),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "email",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.blue ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    )),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "Password",
                    hintText: "password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 10,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.blue,
                      fontSize: 14,
                    )),
              ),
              const SizedBox(
                height: 60,
              ),
              ElevatedButton(
                  onPressed: () {
                    validateForm();
                    //Navigator.push(context,MaterialPageRoute(builder: (c) => CarInfoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 50,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  )),
              TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(0.20),
                  child: Text(
                    "Do not have an Account? Register Here",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SignUpScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
