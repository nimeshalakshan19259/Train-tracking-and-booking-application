import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/authentication/login_screen.dart';
import 'package:users_app/splashScreen/splash_screen.dart';

import '../global/global.dart';
import '../widgets/progress_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController nicTextEditingController = TextEditingController();
  TextEditingController srilankarailwayidTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 3) {
      Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
    } else if (!emailTextEditingController.text.contains("@")) {
      Fluttertoast.showToast(msg: "Email address is not Valid.");
    } else if (phoneTextEditingController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Phone Number is required.");
    } else if (passwordTextEditingController.text.length < 6) {
      Fluttertoast.showToast(msg: "Password must be atleast 6 Characters.");
    } else {
      saveUserInfoNow();
    }
  }

  saveUserInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c) {
          return ProgressDialog(
            message: "Processing, Please wait...",
          );
        });

    final User? firebaseUser = (await fAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Error: " + msg.toString());
    }))
        .user;

    if (firebaseUser != null) {
      Map userMap = {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference usersRef =
          FirebaseDatabase.instance.ref().child("users");
      usersRef.child(firebaseUser.uid).set(userMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: "Account has been Created.");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => MySplashScreen()));
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Account has not been Created.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(children: [
              const SizedBox(
                height: 0.05,
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Image.asset("images/signup.jpg"),
              ),
              const SizedBox(
                height: 0.1,
              ),
              const Text(
                "SignUp",
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: nameTextEditingController,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "Name",
                    hintText: "name",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,),
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
                controller: emailTextEditingController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "Email",
                    hintText: "email",
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue,),
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
                controller: phoneTextEditingController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "Phone",
                    hintText: "phone number",
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
              TextField(
                controller: nicTextEditingController,
                style: const TextStyle(
                  color: Colors.blue,
                ),
                decoration: const InputDecoration(
                    labelText: "NIC",
                    hintText: "NIC",
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
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => LoginScreen()));
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20,),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                    ),

                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(

                      fontSize: 18,
                    ),
                  )),
              TextButton(
                child: const Padding(
                  padding: EdgeInsets.all(0.20),
                  child: Text(
                    "Already Registered? Login here !",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
              ),
            ]),
          ),
        ));
  }
}
